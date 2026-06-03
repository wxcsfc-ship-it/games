extends Control

const TITLE_SCENE := "res://scenes/title_screen.tscn"

@onready var list: VBoxContainer = $Margin/Root/Scroll/List
@onready var title_label: Label = $Margin/Root/Header/TitleLabel
@onready var back_button: Button = $Margin/Root/Header/BackButton

var current_chapter := ""

func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)
	build_list()

func build_list() -> void:
	for child in list.get_children():
		child.queue_free()

	current_chapter = ""
	for level in Progress.get_levels():
		if typeof(level) != TYPE_DICTIONARY:
			continue
		var chapter_id := String(level.get("chapter_id", ""))
		if chapter_id != current_chapter:
			current_chapter = chapter_id
			add_chapter_label(Progress.get_chapter_title(chapter_id))
		add_level_button(level)

func add_chapter_label(chapter_title: String) -> void:
	var label := Label.new()
	label.text = "%s  %s" % [chapter_title, get_chapter_progress_text(current_chapter)]
	label.add_theme_font_size_override("font_size", 26)
	label.add_theme_color_override("font_color", Color(1.0, 0.92, 0.4, 1.0))
	list.add_child(label)

func get_chapter_progress_text(chapter_id: String) -> String:
	var total := 0
	var completed := 0
	for level in Progress.get_levels():
		if typeof(level) != TYPE_DICTIONARY:
			continue
		if String(level.get("chapter_id", "")) != chapter_id:
			continue
		total += 1
		if Progress.is_completed(String(level.get("scene", ""))):
			completed += 1
	return "(%d/%d)" % [completed, total]

func add_level_button(level: Dictionary) -> void:
	var scene_path := String(level.get("scene", ""))
	var button := Button.new()
	button.custom_minimum_size = Vector2(0, 54)
	button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.add_theme_font_size_override("font_size", 20)

	var status := "Open"
	if Progress.is_completed(scene_path):
		var best_time := Progress.get_best_time(scene_path)
		status = "Done  Best %d  %.1fs" % [Progress.get_best_rescued(scene_path), best_time]

	button.text = "%s  -  %s  [%s]" % [
		String(level.get("id", "")),
		String(level.get("title", "")),
		status,
	]
	button.pressed.connect(func() -> void:
		get_tree().change_scene_to_file(scene_path)
	)
	list.add_child(button)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(TITLE_SCENE)
