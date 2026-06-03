extends Node

const SAVE_PATH := "user://progress.cfg"
const LEVELS_PATH := "res://data/levels.json"

var levels: Array = []
var chapters: Array = []
var level_by_scene := {}
var progress := ConfigFile.new()

func _ready() -> void:
	load_level_data()
	progress.load(SAVE_PATH)

func load_level_data() -> void:
	levels.clear()
	chapters.clear()
	level_by_scene.clear()

	var file := FileAccess.open(LEVELS_PATH, FileAccess.READ)
	if file == null:
		push_error("Unable to open %s" % LEVELS_PATH)
		return

	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Unable to parse %s" % LEVELS_PATH)
		return

	chapters = parsed.get("chapters", [])
	levels = parsed.get("levels", [])
	for level in levels:
		if typeof(level) != TYPE_DICTIONARY:
			continue
		level_by_scene[String(level.get("scene", ""))] = level

func get_levels() -> Array:
	return levels

func get_chapter_title(chapter_id: String) -> String:
	for chapter in chapters:
		if String(chapter.get("id", "")) == chapter_id:
			return String(chapter.get("title", chapter_id))
	return chapter_id

func get_level_for_scene(scene_path: String) -> Dictionary:
	return level_by_scene.get(scene_path, {})

func mark_level_complete(scene_path: String, rescued: int, elapsed_time: float) -> void:
	var best_rescued := int(progress.get_value(scene_path, "best_rescued", 0))
	var best_time := float(progress.get_value(scene_path, "best_time", -1.0))
	progress.set_value(scene_path, "completed", true)
	progress.set_value(scene_path, "best_rescued", max(best_rescued, rescued))
	if best_time < 0.0 or elapsed_time < best_time:
		progress.set_value(scene_path, "best_time", elapsed_time)
	progress.save(SAVE_PATH)

func is_completed(scene_path: String) -> bool:
	return bool(progress.get_value(scene_path, "completed", false))

func get_best_rescued(scene_path: String) -> int:
	return int(progress.get_value(scene_path, "best_rescued", 0))

func get_best_time(scene_path: String) -> float:
	return float(progress.get_value(scene_path, "best_time", -1.0))
