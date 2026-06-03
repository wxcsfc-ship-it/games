extends CharacterBody2D

signal rescued
signal died

const SPEED := 120.0
const GRAVITY := 980.0
const DELETE_Y := 480.0
const SAFE_FALL_DISTANCE := 200.0
const PARACHUTE_FALL_SPEED := 140.0
const CLIMB_FORWARD_DISTANCE := 72.0
const CLIMB_UP_DISTANCE := 104.0
const CLIMB_SPEED := 220.0

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

func _physics_process(delta: float) -> void:
	if finished:
		return
	if is_blocker:
		velocity = Vector2.ZERO
		return

	if is_climbing:
		global_position = global_position.move_toward(climb_target, CLIMB_SPEED * delta)
		velocity = Vector2.ZERO
		if global_position == climb_target:
			is_climbing = false
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

func become_blocker() -> bool:
	if finished or is_blocker:
		return false

	is_blocker = true
	velocity = Vector2.ZERO
	collision_layer = 0
	collision_mask = 0
	create_blocker_obstacle()

	var visual := get_node_or_null("Visual") as Polygon2D
	if visual != null:
		visual.color = Color(1.0, 0.85, 0.15, 1.0)

	return true

func open_parachute() -> bool:
	if finished or is_blocker or parachute_open:
		return false

	parachute_open = true
	var parachute := get_node_or_null("Parachute") as Polygon2D
	if parachute != null:
		parachute.visible = true
	return true

func apply_climb() -> bool:
	if finished or is_blocker or climb_ready or is_climbing:
		return false
	if not is_on_floor():
		return false

	climb_ready = true
	var visual := get_node_or_null("Visual") as Polygon2D
	if visual != null:
		visual.color = Color(0.45, 0.85, 1.0, 1.0)
	return true

func start_climbing() -> void:
	climb_ready = false
	is_climbing = true
	was_falling = false
	velocity = Vector2.ZERO
	climb_target = global_position + Vector2(direction * CLIMB_FORWARD_DISTANCE, -CLIMB_UP_DISTANCE)

	var visual := get_node_or_null("Visual") as Polygon2D
	if visual != null:
		visual.color = Color(0.2, 0.65, 1.0, 1.0)

func close_parachute() -> void:
	if not parachute_open:
		return

	parachute_open = false
	var parachute := get_node_or_null("Parachute") as Polygon2D
	if parachute != null:
		parachute.visible = false

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
	rectangle.size = Vector2(32, 32)
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
