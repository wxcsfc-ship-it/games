extends CharacterBody2D

signal rescued
signal died

const WORLD_SCALE := 16.0
const CHARACTER_SIZE := Vector2(32.0, 32.0) * WORLD_SCALE
const SPEED := 120.0 * WORLD_SCALE
const GRAVITY := 980.0 * WORLD_SCALE
const DELETE_Y := 480.0 * WORLD_SCALE
const SAFE_FALL_DISTANCE := 200.0 * WORLD_SCALE
const PARACHUTE_FALL_SPEED := 140.0 * WORLD_SCALE
const CLIMB_FORWARD_DISTANCE := 72.0 * WORLD_SCALE
const CLIMB_UP_DISTANCE := 104.0 * WORLD_SCALE
const CLIMB_SPEED := 220.0 * WORLD_SCALE

var direction := 1.0
var finished := false
var is_blocker := false
var parachute_open := false
var was_falling := false
var fall_start_y := 0.0
var climb_ready := false
var is_climbing := false
var climb_target := Vector2.ZERO
var blocker_obstacle: StaticBody2D
var walk_frame_time := 0.0
var walk_frame_index := 0

@onready var mover_sprite: Sprite2D = get_node_or_null("MoverSprite") as Sprite2D
@onready var parachute_sprite: Sprite2D = get_node_or_null("ParachuteSprite") as Sprite2D

func _ready() -> void:
	configure_collision()
	hide_debug_visuals()
	configure_sprites()

func configure_collision() -> void:
	var collision_shape := get_node_or_null("CollisionShape2D") as CollisionShape2D
	if collision_shape == null:
		return
	var rectangle := RectangleShape2D.new()
	rectangle.size = CHARACTER_SIZE
	collision_shape.shape = rectangle

func hide_debug_visuals() -> void:
	for child in get_children():
		var polygon := child as Polygon2D
		if polygon != null:
			polygon.visible = false

func configure_sprites() -> void:
	if mover_sprite == null:
		mover_sprite = Sprite2D.new()
		mover_sprite.name = "MoverSprite"
		add_child(mover_sprite)
	mover_sprite.texture = VisualAssets.MOVER_IDLE
	mover_sprite.centered = true
	mover_sprite.z_index = 2
	mover_sprite.scale = Vector2.ONE

	if parachute_sprite == null:
		parachute_sprite = Sprite2D.new()
		parachute_sprite.name = "ParachuteSprite"
		add_child(parachute_sprite)
	parachute_sprite.texture = VisualAssets.PARACHUTE_OPEN
	parachute_sprite.centered = true
	parachute_sprite.visible = false
	parachute_sprite.z_index = 1
	parachute_sprite.scale = Vector2.ONE

	update_visual_state()

func _physics_process(delta: float) -> void:
	if finished:
		return
	if is_blocker:
		velocity = Vector2.ZERO
		update_visual_state()
		return

	if is_climbing:
		global_position = global_position.move_toward(climb_target, CLIMB_SPEED * delta)
		velocity = Vector2.ZERO
		if global_position == climb_target:
			is_climbing = false
		update_visual_state()
		return

	if is_on_floor():
		velocity.y = 0.0
	else:
		if not was_falling:
			was_falling = true
			fall_start_y = global_position.y
		velocity.y += GRAVITY * delta
		if parachute_open and velocity.y > PARACHUTE_FALL_SPEED:
			velocity.y = PARACHUTE_FALL_SPEED

	velocity.x = SPEED * direction
	move_and_slide()
	advance_walk_frame(delta)
	if is_on_floor() and was_falling:
		var fall_distance := global_position.y - fall_start_y
		was_falling = false
		if fall_distance > SAFE_FALL_DISTANCE and not parachute_open:
			die()
			return
		close_parachute()

	if is_on_wall():
		if climb_ready:
			start_climbing()
			return
		direction *= -1.0

	if global_position.y > DELETE_Y:
		die()

	update_visual_state()

func advance_walk_frame(delta: float) -> void:
	if not is_on_floor() or absf(velocity.x) <= 0.0:
		return
	walk_frame_time += delta
	if walk_frame_time >= 0.18:
		walk_frame_time = 0.0
		walk_frame_index = 1 - walk_frame_index

func update_visual_state() -> void:
	if mover_sprite == null:
		return

	if is_blocker:
		mover_sprite.texture = VisualAssets.MOVER_BLOCKER
	elif climb_ready or is_climbing:
		mover_sprite.texture = VisualAssets.MOVER_CLIMB_READY
	elif is_on_floor() and absf(velocity.x) > 0.0:
		mover_sprite.texture = VisualAssets.MOVER_WALK_01 if walk_frame_index == 0 else VisualAssets.MOVER_WALK_02
	else:
		mover_sprite.texture = VisualAssets.MOVER_IDLE

	mover_sprite.scale = Vector2(direction, 1.0)
	if parachute_sprite != null:
		parachute_sprite.visible = parachute_open
		parachute_sprite.scale = Vector2(direction, 1.0)

func become_blocker() -> bool:
	if finished or is_blocker:
		return false

	is_blocker = true
	velocity = Vector2.ZERO
	collision_layer = 0
	collision_mask = 0
	create_blocker_obstacle()

	update_visual_state()
	return true

func open_parachute() -> bool:
	if finished or is_blocker or parachute_open:
		return false

	parachute_open = true
	update_visual_state()
	return true

func apply_climb() -> bool:
	if finished or is_blocker or climb_ready or is_climbing:
		return false
	if not is_on_floor():
		return false

	climb_ready = true
	update_visual_state()
	return true

func start_climbing() -> void:
	climb_ready = false
	is_climbing = true
	was_falling = false
	velocity = Vector2.ZERO
	climb_target = global_position + Vector2(direction * CLIMB_FORWARD_DISTANCE, -CLIMB_UP_DISTANCE)

	update_visual_state()

func close_parachute() -> void:
	if not parachute_open:
		return

	parachute_open = false
	update_visual_state()

func create_blocker_obstacle() -> void:
	var parent := get_parent()
	if parent == null:
		return

	blocker_obstacle = StaticBody2D.new()
	blocker_obstacle.name = "BlockerObstacle"
	blocker_obstacle.collision_layer = 1
	blocker_obstacle.collision_mask = 2

	var collision_shape := CollisionShape2D.new()
	var rectangle := RectangleShape2D.new()
	rectangle.size = CHARACTER_SIZE
	collision_shape.shape = rectangle
	blocker_obstacle.add_child(collision_shape)

	parent.add_child(blocker_obstacle)
	blocker_obstacle.global_position = global_position

func rescue() -> void:
	if finished:
		return

	finished = true
	velocity = Vector2.ZERO
	rescued.emit()
	remove_blocker_obstacle()
	queue_free()

func die() -> void:
	if finished:
		return

	finished = true
	velocity = Vector2.ZERO
	died.emit()
	remove_blocker_obstacle()
	queue_free()

func remove_blocker_obstacle() -> void:
	if is_instance_valid(blocker_obstacle):
		blocker_obstacle.queue_free()
