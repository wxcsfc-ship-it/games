extends Control

@export var first_level_scene: PackedScene
@export_file("*.tscn") var level_select_scene := "res://scenes/level_select.tscn"

@onready var start_button: Button = $CenterPanel/Content/StartButton

func _ready() -> void:
	start_button.icon = VisualAssets.ICON_LEVELS
	start_button.expand_icon = true
	start_button.pressed.connect(_on_start_button_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_start_game()

func _on_start_button_pressed() -> void:
	_start_game()

func _start_game() -> void:
	if level_select_scene != "":
		get_tree().change_scene_to_file(level_select_scene)
	elif first_level_scene != null:
		get_tree().change_scene_to_packed(first_level_scene)
