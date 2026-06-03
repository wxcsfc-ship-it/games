extends Node2D

@export var auto_mover_scene: PackedScene
@export var total_to_spawn := 5
@export var spawn_interval := 1.5
@export var blocker_enabled := true
@export var blocker_uses := 2
@export var builder_enabled := false
@export var builder_uses := 0
@export var digger_enabled := false
@export var digger_uses := 0
@export var parachuter_enabled := false
@export var parachuter_uses := 0
@export var climber_enabled := false
@export var climber_uses := 0
@export var rescue_goal := 3
@export var time_limit_seconds := 30.0
@export var next_level_scene: PackedScene
@export_file("*.tscn") var level_select_scene := "res://scenes/level_select.tscn"

const BRIDGE_LENGTH := 160.0
const BRIDGE_HEIGHT := 16.0
const DIG_DISTANCE := 96.0
const DIG_HALF_HEIGHT := 56.0

var generated_count := 0
var rescued_count := 0
var dead_count := 0
var selected_ability := ""
var game_over := false
var elapsed_time := 0.0

@onready var spawn_point: Marker2D = $SpawnPoint
@onready var spawn_timer: Timer = $SpawnTimer
@onready var ability_panel: Control = get_node_or_null("AbilityUI/AbilityPanel") as Control
@onready var blocker_button: Button = get_node_or_null("AbilityUI/AbilityPanel/AbilityBar/BlockerButton") as Button
@onready var builder_button: Button = get_node_or_null("AbilityUI/AbilityPanel/AbilityBar/BuilderButton") as Button
@onready var digger_button: Button = get_node_or_null("AbilityUI/AbilityPanel/AbilityBar/DiggerButton") as Button
@onready var parachuter_button: Button = get_node_or_null("AbilityUI/AbilityPanel/AbilityBar/ParachuterButton") as Button
@onready var climber_button: Button = get_node_or_null("AbilityUI/AbilityPanel/AbilityBar/ClimberButton") as Button
@onready var rescue_label: Label = get_node_or_null("AbilityUI/RescueLabel") as Label
@onready var status_label: Label = get_node_or_null("AbilityUI/StatusLabel") as Label
@onready var result_detail_label: Label = get_node_or_null("AbilityUI/ResultDetailLabel") as Label
@onready var restart_button: Button = get_node_or_null("AbilityUI/RestartButton") as Button
@onready var next_button: Button = get_node_or_null("AbilityUI/NextButton") as Button
@onready var menu_button: Button = get_node_or_null("AbilityUI/MenuButton") as Button
@onready var audio_manager: Node = get_node_or_null("AbilityUI/AudioManager")

func _ready() -> void:
	if blocker_enabled:
		selected_ability = "blocker"
	elif builder_enabled:
		selected_ability = "builder"
	elif digger_enabled:
		selected_ability = "digger"
	elif parachuter_enabled:
		selected_ability = "parachuter"
	elif climber_enabled:
		selected_ability = "climber"

	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	if blocker_button != null:
		blocker_button.toggled.connect(_on_blocker_button_toggled)
	if builder_button != null:
		builder_button.toggled.connect(_on_builder_button_toggled)
	if digger_button != null:
		digger_button.toggled.connect(_on_digger_button_toggled)
	if parachuter_button != null:
		parachuter_button.toggled.connect(_on_parachuter_button_toggled)
	if climber_button != null:
		climber_button.toggled.connect(_on_climber_button_toggled)
	if blocker_button != null or builder_button != null or digger_button != null or parachuter_button != null or climber_button != null:
		update_ability_ui()
	if restart_button != null:
		restart_button.pressed.connect(_on_restart_button_pressed)
	if next_button != null:
		next_button.pressed.connect(_on_next_button_pressed)
	if menu_button != null:
		menu_button.pressed.connect(_on_menu_button_pressed)
	if status_label != null:
		status_label.text = ""
	if result_detail_label != null:
		result_detail_label.visible = false
		result_detail_label.text = ""
	update_status_ui()

	spawn_next_mover()
	if generated_count < total_to_spawn:
		spawn_timer.start()
	update_status_ui()

func _process(delta: float) -> void:
	if game_over:
		return
	if time_limit_seconds <= 0.0:
		return

	elapsed_time += delta
	update_status_ui()
	if elapsed_time >= time_limit_seconds:
		finish_game("Time Up")

func _unhandled_input(event: InputEvent) -> void:
	if game_over:
		return
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			try_apply_selected_ability_at(get_global_mouse_position())

func spawn_next_mover() -> void:
	if game_over:
		return
	if generated_count >= total_to_spawn:
		return
	if auto_mover_scene == null:
		push_error("Auto mover scene is not assigned.")
		return

	var mover: CharacterBody2D = auto_mover_scene.instantiate() as CharacterBody2D
	if mover == null:
		push_error("Auto mover scene root must be CharacterBody2D.")
		return

	add_child(mover)
	mover.global_position = spawn_point.global_position
	generated_count += 1
	update_status_ui()

	if mover.has_signal("rescued"):
		mover.rescued.connect(_on_mover_rescued)
	if mover.has_signal("died"):
		mover.died.connect(_on_mover_died)

	check_game_state()

func _on_spawn_timer_timeout() -> void:
	spawn_next_mover()
	if generated_count >= total_to_spawn:
		spawn_timer.stop()

func try_apply_selected_ability_at(world_position: Vector2) -> bool:
	if selected_ability == "blocker":
		return try_apply_blocker_at(world_position)
	if selected_ability == "builder":
		return try_apply_builder_at(world_position)
	if selected_ability == "digger":
		return try_apply_digger_at(world_position)
	if selected_ability == "parachuter":
		return try_apply_parachuter_at(world_position)
	if selected_ability == "climber":
		return try_apply_climber_at(world_position)

	return false

func try_apply_blocker_at(world_position: Vector2) -> bool:
	if game_over:
		return false
	if not blocker_enabled or blocker_uses <= 0:
		return false

	var mover := find_mover_at(world_position)
	if mover == null or not mover.has_method("become_blocker"):
		return false
	if not mover.become_blocker():
		return false

	blocker_uses -= 1
	if audio_manager != null:
		audio_manager.play_ability()
	update_ability_ui()
	check_game_state()
	return true

func try_apply_builder_at(world_position: Vector2) -> bool:
	if game_over:
		return false
	if not builder_enabled or builder_uses <= 0:
		return false

	var mover := find_mover_at(world_position)
	if mover == null:
		return false
	if bool(mover.get("finished")) or bool(mover.get("is_blocker")):
		return false
	if not mover.is_on_floor():
		return false

	create_bridge_for(mover)
	builder_uses -= 1
	if audio_manager != null:
		audio_manager.play_ability()
	update_ability_ui()
	check_game_state()
	return true

func try_apply_digger_at(world_position: Vector2) -> bool:
	if game_over:
		return false
	if not digger_enabled or digger_uses <= 0:
		return false

	var mover := find_mover_at(world_position)
	if mover == null:
		return false
	if bool(mover.get("finished")) or bool(mover.get("is_blocker")):
		return false

	var diggable := find_diggable_for(mover)
	if diggable == null:
		return false

	diggable.queue_free()
	digger_uses -= 1
	if audio_manager != null:
		audio_manager.play_ability()
	update_ability_ui()
	check_game_state()
	return true

func try_apply_parachuter_at(world_position: Vector2) -> bool:
	if game_over:
		return false
	if not parachuter_enabled or parachuter_uses <= 0:
		return false

	var mover := find_mover_at(world_position)
	if mover == null or not mover.has_method("open_parachute"):
		return false
	if not mover.open_parachute():
		return false

	parachuter_uses -= 1
	if audio_manager != null:
		audio_manager.play_ability()
	update_ability_ui()
	check_game_state()
	return true

func try_apply_climber_at(world_position: Vector2) -> bool:
	if game_over:
		return false
	if not climber_enabled or climber_uses <= 0:
		return false

	var mover := find_mover_at(world_position)
	if mover == null or not mover.has_method("apply_climb"):
		return false
	if not mover.apply_climb():
		return false

	climber_uses -= 1
	if audio_manager != null:
		audio_manager.play_ability()
	update_ability_ui()
	check_game_state()
	return true

func create_bridge_for(mover: CharacterBody2D) -> void:
	var direction := float(mover.get("direction"))
	if direction == 0.0:
		direction = 1.0

	var bridge := StaticBody2D.new()
	bridge.name = "Bridge"
	bridge.collision_layer = 1
	bridge.collision_mask = 2

	var collision_shape := CollisionShape2D.new()
	collision_shape.name = "CollisionShape2D"
	var rectangle := RectangleShape2D.new()
	rectangle.size = Vector2(BRIDGE_LENGTH, BRIDGE_HEIGHT)
	collision_shape.shape = rectangle
	collision_shape.one_way_collision = true
	bridge.add_child(collision_shape)

	var visual := Polygon2D.new()
	visual.name = "Visual"
	visual.color = Color(0.55, 0.38, 0.2, 1.0)
	visual.polygon = PackedVector2Array([
		Vector2(-BRIDGE_LENGTH / 2.0, -BRIDGE_HEIGHT / 2.0),
		Vector2(BRIDGE_LENGTH / 2.0, -BRIDGE_HEIGHT / 2.0),
		Vector2(BRIDGE_LENGTH / 2.0, BRIDGE_HEIGHT / 2.0),
		Vector2(-BRIDGE_LENGTH / 2.0, BRIDGE_HEIGHT / 2.0)
	])
	bridge.add_child(visual)

	add_child(bridge)
	var bridge_position := mover.global_position + Vector2(direction * (BRIDGE_LENGTH / 2.0 + 12.0), 24.0)
	bridge.global_position = Vector2(roundf(bridge_position.x), roundf(bridge_position.y))

func find_diggable_for(mover: CharacterBody2D) -> Node2D:
	var direction := float(mover.get("direction"))
	if direction == 0.0:
		direction = 1.0

	for node in get_tree().get_nodes_in_group("diggable"):
		var diggable := node as Node2D
		if diggable == null or not is_ancestor_of(diggable):
			continue

		var offset := diggable.global_position - mover.global_position
		var in_front := offset.x * direction >= 0.0 and offset.x * direction <= DIG_DISTANCE and absf(offset.y) <= DIG_HALF_HEIGHT
		var below := absf(offset.x) <= DIG_DISTANCE * 0.5 and offset.y > 0.0 and offset.y <= DIG_HALF_HEIGHT
		if in_front or below:
			return diggable

	return null

func find_mover_at(world_position: Vector2) -> CharacterBody2D:
	for child in get_children():
		var mover := child as CharacterBody2D
		if mover == null:
			continue
		if absf(mover.global_position.x - world_position.x) <= 16.0 and absf(mover.global_position.y - world_position.y) <= 16.0:
			return mover

	return null

func _on_blocker_button_toggled(button_pressed: bool) -> void:
	if button_pressed:
		selected_ability = "blocker"
		if builder_button != null:
			builder_button.set_pressed_no_signal(false)
		if digger_button != null:
			digger_button.set_pressed_no_signal(false)
		if parachuter_button != null:
			parachuter_button.set_pressed_no_signal(false)
		if climber_button != null:
			climber_button.set_pressed_no_signal(false)
	elif selected_ability == "blocker":
		selected_ability = ""
	update_ability_ui()

func _on_builder_button_toggled(button_pressed: bool) -> void:
	if button_pressed:
		selected_ability = "builder"
		if blocker_button != null:
			blocker_button.set_pressed_no_signal(false)
		if digger_button != null:
			digger_button.set_pressed_no_signal(false)
		if parachuter_button != null:
			parachuter_button.set_pressed_no_signal(false)
		if climber_button != null:
			climber_button.set_pressed_no_signal(false)
	elif selected_ability == "builder":
		selected_ability = ""
	update_ability_ui()

func _on_digger_button_toggled(button_pressed: bool) -> void:
	if button_pressed:
		selected_ability = "digger"
		if blocker_button != null:
			blocker_button.set_pressed_no_signal(false)
		if builder_button != null:
			builder_button.set_pressed_no_signal(false)
		if parachuter_button != null:
			parachuter_button.set_pressed_no_signal(false)
		if climber_button != null:
			climber_button.set_pressed_no_signal(false)
	elif selected_ability == "digger":
		selected_ability = ""
	update_ability_ui()

func _on_parachuter_button_toggled(button_pressed: bool) -> void:
	if button_pressed:
		selected_ability = "parachuter"
		if blocker_button != null:
			blocker_button.set_pressed_no_signal(false)
		if builder_button != null:
			builder_button.set_pressed_no_signal(false)
		if digger_button != null:
			digger_button.set_pressed_no_signal(false)
		if climber_button != null:
			climber_button.set_pressed_no_signal(false)
	elif selected_ability == "parachuter":
		selected_ability = ""
	update_ability_ui()

func _on_climber_button_toggled(button_pressed: bool) -> void:
	if button_pressed:
		selected_ability = "climber"
		if blocker_button != null:
			blocker_button.set_pressed_no_signal(false)
		if builder_button != null:
			builder_button.set_pressed_no_signal(false)
		if digger_button != null:
			digger_button.set_pressed_no_signal(false)
		if parachuter_button != null:
			parachuter_button.set_pressed_no_signal(false)
		if climber_button != null:
			climber_button.set_pressed_no_signal(false)
	elif selected_ability == "climber":
		selected_ability = ""
	update_ability_ui()

func update_ability_ui() -> void:
	if ability_panel != null:
		ability_panel.visible = blocker_enabled or builder_enabled or digger_enabled or parachuter_enabled or climber_enabled

	if blocker_button != null:
		blocker_button.visible = blocker_enabled
		blocker_button.text = "Blocker: %d" % blocker_uses
		blocker_button.disabled = game_over or not blocker_enabled or blocker_uses <= 0
		blocker_button.set_pressed_no_signal(selected_ability == "blocker")

	if builder_button != null:
		builder_button.visible = builder_enabled
		builder_button.text = "Builder: %d" % builder_uses
		builder_button.disabled = game_over or not builder_enabled or builder_uses <= 0
		builder_button.set_pressed_no_signal(selected_ability == "builder")

	if digger_button != null:
		digger_button.visible = digger_enabled
		digger_button.text = "Digger: %d" % digger_uses
		digger_button.disabled = game_over or not digger_enabled or digger_uses <= 0
		digger_button.set_pressed_no_signal(selected_ability == "digger")

	if parachuter_button != null:
		parachuter_button.visible = parachuter_enabled
		parachuter_button.text = "Parachute: %d" % parachuter_uses
		parachuter_button.disabled = game_over or not parachuter_enabled or parachuter_uses <= 0
		parachuter_button.set_pressed_no_signal(selected_ability == "parachuter")

	if climber_button != null:
		climber_button.visible = climber_enabled
		climber_button.text = "Climber: %d" % climber_uses
		climber_button.disabled = game_over or not climber_enabled or climber_uses <= 0
		climber_button.set_pressed_no_signal(selected_ability == "climber")

func update_status_ui() -> void:
	if rescue_label != null:
		var time_remaining := maxf(0.0, time_limit_seconds - elapsed_time)
		rescue_label.text = "Rescued: %d/%d  Lost: %d  Spawned: %d/%d  Time: %d" % [
			rescued_count,
			rescue_goal,
			dead_count,
			generated_count,
			total_to_spawn,
			int(ceil(time_remaining)),
		]

func _on_mover_rescued() -> void:
	if game_over:
		return

	rescued_count += 1
	if audio_manager != null:
		audio_manager.play_rescue()
	update_status_ui()
	check_game_state()

func _on_mover_died() -> void:
	if game_over:
		return

	dead_count += 1
	if audio_manager != null:
		audio_manager.play_die()
	update_status_ui()
	check_game_state()

func check_game_state() -> void:
	if game_over:
		return

	if rescued_count >= rescue_goal:
		finish_game("Victory")
		return

	var remaining_possible := (total_to_spawn - generated_count) + count_rescueable_active_movers()
	if rescued_count + remaining_possible < rescue_goal:
		finish_game("Not Enough Saved")

func count_rescueable_active_movers() -> int:
	var count := 0
	for child in get_children():
		var mover := child as CharacterBody2D
		if mover == null:
			continue
		if bool(mover.get("finished")):
			continue
		if bool(mover.get("is_blocker")):
			continue
		count += 1

	return count

func finish_game(message: String) -> void:
	game_over = true
	spawn_timer.stop()
	if message == "Victory":
		Progress.mark_level_complete(scene_file_path, rescued_count, elapsed_time)
	if status_label != null:
		status_label.text = message
	if result_detail_label != null:
		result_detail_label.text = get_result_detail(message)
		result_detail_label.visible = result_detail_label.text != ""
	if audio_manager != null:
		if message == "Victory":
			audio_manager.play_victory()
		else:
			audio_manager.play_failure()
	if next_button != null:
		next_button.visible = message == "Victory"
		if message == "Victory":
			next_button.text = "Next" if next_level_scene != null else "Levels"
	update_ability_ui()

func get_result_detail(message: String) -> String:
	if message == "Victory":
		return "Saved %d/%d in %.1fs" % [rescued_count, total_to_spawn, elapsed_time]
	if message == "Time Up":
		return "Time ran out. Saved %d/%d; goal is %d." % [rescued_count, total_to_spawn, rescue_goal]
	if message == "Not Enough Saved":
		return "Too many walkers were lost or blocked. Saved %d/%d; goal is %d." % [rescued_count, total_to_spawn, rescue_goal]
	return ""

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_next_button_pressed() -> void:
	if next_level_scene != null:
		get_tree().change_scene_to_packed(next_level_scene)
	elif level_select_scene != "":
		get_tree().change_scene_to_file(level_select_scene)

func _on_menu_button_pressed() -> void:
	if level_select_scene != "":
		get_tree().change_scene_to_file(level_select_scene)
