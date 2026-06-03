extends Node

const WORLD_SCALE := 16.0
const CAMERA_LEFT_PADDING := 40.0
const CAMERA_RIGHT_PADDING := 40.0
const CAMERA_TOP_PADDING := 96.0
const CAMERA_BOTTOM_PADDING := 176.0
const CAMERA_MAX_ZOOM := 0.15
const BACKDROP_LAYER := -100
const REGION_ALIGN_CENTER := 0
const REGION_ALIGN_TOP := -1
const REGION_ALIGN_BOTTOM := 1

var MOVER_IDLE: Texture2D
var MOVER_WALK_01: Texture2D
var MOVER_WALK_02: Texture2D
var MOVER_BLOCKER: Texture2D
var MOVER_CLIMB_READY: Texture2D
var PARACHUTE_OPEN: Texture2D

var FLOOR_TOP: Texture2D
var WALL_SOLID: Texture2D
var WALL_DIGGABLE: Texture2D
var BRIDGE_PLANK: Texture2D
var HAZARD_PIT: Texture2D
var DROP_DEADLY: Texture2D
var DROP_SAFE: Texture2D

var SPAWN_GATE: Texture2D
var EXIT_FRAME: Texture2D
var EXIT_INNER: Texture2D
var DIGGABLE_CRACKS: Texture2D

var ICON_BLOCKER: Texture2D
var ICON_BUILDER: Texture2D
var ICON_DIGGER: Texture2D
var ICON_PARACHUTE: Texture2D
var ICON_CLIMBER: Texture2D
var ICON_RESTART: Texture2D
var ICON_NEXT: Texture2D
var ICON_LEVELS: Texture2D
var ICON_COMPLETED: Texture2D

func _ready() -> void:
	load_textures()

func load_textures() -> void:
	MOVER_IDLE = load_png_texture("res://assets/processed/sprites/mover_idle.png")
	MOVER_WALK_01 = load_png_texture("res://assets/processed/sprites/mover_walk_01.png")
	MOVER_WALK_02 = load_png_texture("res://assets/processed/sprites/mover_walk_02.png")
	MOVER_BLOCKER = load_png_texture("res://assets/processed/sprites/mover_blocker.png")
	MOVER_CLIMB_READY = load_png_texture("res://assets/processed/sprites/mover_climb_ready.png")
	PARACHUTE_OPEN = load_png_texture("res://assets/processed/sprites/parachute_open.png")

	FLOOR_TOP = load_png_texture("res://assets/processed/tiles/floor_top.png")
	WALL_SOLID = load_png_texture("res://assets/processed/tiles/wall_solid.png")
	WALL_DIGGABLE = load_png_texture("res://assets/processed/tiles/wall_diggable.png")
	BRIDGE_PLANK = load_png_texture("res://assets/processed/tiles/bridge_plank.png")
	HAZARD_PIT = load_png_texture("res://assets/processed/tiles/hazard_pit.png")
	DROP_DEADLY = load_png_texture("res://assets/processed/tiles/drop_deadly_marker.png")
	DROP_SAFE = load_png_texture("res://assets/processed/tiles/drop_safe_marker.png")

	SPAWN_GATE = load_png_texture("res://assets/processed/props/spawn_gate.png")
	EXIT_FRAME = load_png_texture("res://assets/processed/props/exit_frame.png")
	EXIT_INNER = load_png_texture("res://assets/processed/props/exit_inner.png")
	DIGGABLE_CRACKS = load_png_texture("res://assets/processed/props/diggable_cracks.png")

	ICON_BLOCKER = load_png_texture("res://assets/processed/ui/icon_blocker.png")
	ICON_BUILDER = load_png_texture("res://assets/processed/ui/icon_builder.png")
	ICON_DIGGER = load_png_texture("res://assets/processed/ui/icon_digger.png")
	ICON_PARACHUTE = load_png_texture("res://assets/processed/ui/icon_parachute.png")
	ICON_CLIMBER = load_png_texture("res://assets/processed/ui/icon_climber.png")
	ICON_RESTART = load_png_texture("res://assets/processed/ui/icon_restart.png")
	ICON_NEXT = load_png_texture("res://assets/processed/ui/icon_next.png")
	ICON_LEVELS = load_png_texture("res://assets/processed/ui/icon_levels.png")
	ICON_COMPLETED = load_png_texture("res://assets/processed/ui/icon_completed.png")

func load_png_texture(path: String) -> Texture2D:
	var image := Image.new()
	var error := image.load(ProjectSettings.globalize_path(path))
	if error != OK:
		push_error("Unable to load texture %s" % path)
		image = Image.create(16, 16, false, Image.FORMAT_RGBA8)
		image.fill(Color(1.0, 0.0, 1.0, 1.0))
	else:
		image.convert(Image.FORMAT_RGBA8)
		var bounds := _opaque_bounds(image)
		if bounds.size.x > 0 and bounds.size.y > 0 and bounds.size != Vector2i(image.get_width(), image.get_height()):
			image = image.get_region(bounds)
	return ImageTexture.create_from_image(image)

func scaled(value: float) -> float:
	return value * WORLD_SCALE

func scaled_vector(value: Vector2) -> Vector2:
	return value * WORLD_SCALE

func prepare_level(root: Node2D) -> void:
	if bool(root.get_meta("visual_assets_prepared", false)):
		return
	root.set_meta("visual_assets_prepared", true)

	for child in root.get_children():
		_scale_existing_level_node(child)

	install_backdrop(root)
	install_camera(root)
	replace_level_visuals(root)

func install_backdrop(root: Node2D) -> void:
	var layer := root.get_node_or_null("VisualBackdropLayer") as CanvasLayer
	if layer == null:
		layer = CanvasLayer.new()
		layer.name = "VisualBackdropLayer"
		root.add_child(layer)
	layer.layer = BACKDROP_LAYER

	var sky := layer.get_node_or_null("Sky") as ColorRect
	if sky == null:
		sky = ColorRect.new()
		sky.name = "Sky"
		layer.add_child(sky)
	sky.anchor_left = 0.0
	sky.anchor_top = 0.0
	sky.anchor_right = 1.0
	sky.anchor_bottom = 1.0
	sky.offset_left = 0.0
	sky.offset_top = 0.0
	sky.offset_right = 0.0
	sky.offset_bottom = 0.0
	sky.color = Color(0.16, 0.18, 0.20, 1.0)
	sky.mouse_filter = Control.MOUSE_FILTER_IGNORE

func install_camera(root: Node2D) -> void:
	var camera := root.get_node_or_null("VisualCamera") as Camera2D
	if camera == null:
		camera = Camera2D.new()
		camera.name = "VisualCamera"
		root.add_child(camera)

	var viewport_size := root.get_viewport_rect().size
	var bounds := _level_bounds(root)
	var usable_size := Vector2(
		maxf(1.0, viewport_size.x - CAMERA_LEFT_PADDING - CAMERA_RIGHT_PADDING),
		maxf(1.0, viewport_size.y - CAMERA_TOP_PADDING - CAMERA_BOTTOM_PADDING)
	)
	var zoom_value := minf(usable_size.x / bounds.size.x, usable_size.y / bounds.size.y)
	zoom_value = minf(zoom_value, CAMERA_MAX_ZOOM)

	var usable_center := Vector2(
		CAMERA_LEFT_PADDING + usable_size.x * 0.5,
		CAMERA_TOP_PADDING + usable_size.y * 0.5
	)
	var screen_offset := usable_center - viewport_size * 0.5
	camera.global_position = bounds.get_center() - screen_offset / zoom_value
	camera.zoom = Vector2(zoom_value, zoom_value)
	camera.enabled = true
	camera.make_current()

func _scale_existing_level_node(node: Node) -> void:
	if node is CanvasLayer or node is Camera2D:
		return

	var node2d := node as Node2D
	if node2d != null:
		node2d.position *= WORLD_SCALE

	var collision_shape := node as CollisionShape2D
	if collision_shape != null:
		_scale_collision_shape(collision_shape)

	var polygon := node as Polygon2D
	if polygon != null:
		var scaled_points := PackedVector2Array()
		for point in polygon.polygon:
			scaled_points.append(point * WORLD_SCALE)
		polygon.polygon = scaled_points

	for child in node.get_children():
		_scale_existing_level_node(child)

func _scale_collision_shape(collision_shape: CollisionShape2D) -> void:
	if collision_shape.shape == null:
		return

	var shape := collision_shape.shape.duplicate()
	if shape is RectangleShape2D:
		var rectangle := shape as RectangleShape2D
		rectangle.size *= WORLD_SCALE
	collision_shape.shape = shape

func replace_level_visuals(root: Node2D) -> void:
	for child in root.get_children():
		_replace_visual_for_node(child)

func _replace_visual_for_node(node: Node) -> void:
	if node is CanvasLayer or node is Camera2D:
		return

	var marker := node as Marker2D
	if marker != null and marker.name == "SpawnPoint":
		install_spawn_visual(marker)

	var area := node as Area2D
	if area != null and node.name.to_lower().contains("exit"):
		install_exit_visual(area)

	var body := node as StaticBody2D
	if body != null:
		install_body_visual(body)

	var polygon := node as Polygon2D
	if polygon != null and _is_hazard_marker(polygon):
		install_marker_visual(polygon)

	for child in node.get_children():
		_replace_visual_for_node(child)

func install_body_visual(body: StaticBody2D) -> void:
	var size := _collision_size(body)
	if size == Vector2.ZERO:
		return

	hide_polygon_children(body)
	var lower_name := body.name.to_lower()
	if body.is_in_group("diggable") or lower_name.contains("diggable") or lower_name.contains("weak"):
		add_solid_rect(body, size, "DiggableFill", Color(0.42, 0.25, 0.16, 1.0), -4)
		add_repeated_texture(body, WALL_DIGGABLE, size, "DiggableTexture", -2)
		add_centered_region(body, DIGGABLE_CRACKS, size, "CracksTexture", -1)
	elif lower_name.contains("wall"):
		add_solid_rect(body, size, "WallFill", Color(0.25, 0.22, 0.20, 1.0), -4)
		add_repeated_texture(body, WALL_SOLID, size, "WallTexture", -2)
	else:
		add_solid_rect(body, size, "FloorFill", Color(0.29, 0.22, 0.15, 1.0), -4)
		add_repeated_texture(body, FLOOR_TOP, size, "FloorTexture", -2, Vector2.ZERO, REGION_ALIGN_TOP)

func install_marker_visual(marker: Polygon2D) -> void:
	if marker.polygon.is_empty():
		return

	var bounds := _polygon_bounds(marker.polygon)
	marker.color = Color(marker.color.r, marker.color.g, marker.color.b, 0.0)
	var texture: Texture2D = HAZARD_PIT
	var lower_name := marker.name.to_lower()
	if lower_name.contains("drop"):
		texture = DROP_SAFE if lower_name.contains("safe") or lower_name.contains("mid") or lower_name.contains("left") else DROP_DEADLY

	add_repeated_texture(marker, texture, bounds.size, "MarkerTexture", -3, bounds.get_center())

func install_spawn_visual(spawn: Marker2D) -> void:
	hide_polygon_children(spawn)
	add_centered_texture(spawn, SPAWN_GATE, "SpawnGate", -1)

func install_exit_visual(exit: Area2D) -> void:
	hide_polygon_children(exit)
	add_centered_texture(exit, EXIT_INNER, "ExitInner", -2)
	add_centered_texture(exit, EXIT_FRAME, "ExitFrame", -1)

func add_centered_texture(parent: Node2D, texture: Texture2D, node_name: String, z: int) -> Sprite2D:
	var existing := parent.get_node_or_null(node_name) as Sprite2D
	var sprite := existing if existing != null else Sprite2D.new()
	sprite.name = node_name
	sprite.texture = texture
	sprite.centered = true
	sprite.z_index = z
	sprite.scale = Vector2.ONE
	if existing == null:
		parent.add_child(sprite)
	return sprite

func add_centered_region(parent: Node2D, texture: Texture2D, target_size: Vector2, node_name: String, z: int) -> Sprite2D:
	var sprite := add_centered_texture(parent, texture, node_name, z)
	sprite.region_enabled = true
	sprite.region_rect = _texture_region(texture, target_size)
	return sprite

func add_repeated_texture(parent: Node2D, texture: Texture2D, target_size: Vector2, prefix: String, z: int, local_center := Vector2.ZERO, vertical_align := REGION_ALIGN_CENTER) -> void:
	if target_size.x <= 0.0 or target_size.y <= 0.0:
		return

	for child in parent.get_children():
		if child.name.begins_with(prefix):
			child.queue_free()

	var texture_size := Vector2(texture.get_width(), texture.get_height())
	var tile_size := Vector2(minf(texture_size.x, target_size.x), minf(texture_size.y, target_size.y))
	var columns: int = max(1, int(ceil(target_size.x / tile_size.x)))
	var rows: int = max(1, int(ceil(target_size.y / tile_size.y)))
	var origin := local_center - target_size * 0.5

	for y in range(rows):
		for x in range(columns):
			var remaining := target_size - Vector2(float(x) * tile_size.x, float(y) * tile_size.y)
			var cell_size := Vector2(minf(tile_size.x, remaining.x), minf(tile_size.y, remaining.y))
			var sprite := Sprite2D.new()
			sprite.name = "%s_%d_%d" % [prefix, x, y]
			sprite.texture = texture
			sprite.centered = true
			sprite.region_enabled = true
			sprite.region_rect = _texture_region(texture, cell_size, vertical_align)
			sprite.position = origin + Vector2(float(x) * tile_size.x, float(y) * tile_size.y) + cell_size * 0.5
			sprite.z_index = z
			sprite.scale = Vector2.ONE
			parent.add_child(sprite)

func add_solid_rect(parent: Node2D, target_size: Vector2, node_name: String, color: Color, z: int, local_center := Vector2.ZERO) -> Polygon2D:
	var existing := parent.get_node_or_null(node_name) as Polygon2D
	var polygon := existing if existing != null else Polygon2D.new()
	polygon.name = node_name
	var half := target_size * 0.5
	polygon.polygon = PackedVector2Array([
		local_center + Vector2(-half.x, -half.y),
		local_center + Vector2(half.x, -half.y),
		local_center + Vector2(half.x, half.y),
		local_center + Vector2(-half.x, half.y),
	])
	polygon.color = color
	polygon.z_index = z
	polygon.visible = true
	if existing == null:
		parent.add_child(polygon)
	return polygon

func hide_polygon_children(parent: Node) -> void:
	for child in parent.get_children():
		var polygon := child as Polygon2D
		if polygon != null:
			polygon.visible = false

func make_bridge_visual(parent: Node2D, size: Vector2) -> void:
	hide_polygon_children(parent)
	add_solid_rect(parent, size, "BridgeFill", Color(0.31, 0.21, 0.12, 1.0), -3)
	add_repeated_texture(parent, BRIDGE_PLANK, size, "BridgeTexture", -1)

func configure_ability_button(button: Button, texture: Texture2D, count: int, selected: bool, disabled: bool) -> void:
	button.icon = texture
	button.expand_icon = true
	button.text = str(count)
	button.tooltip_text = button.name.replace("Button", "")
	button.disabled = disabled
	if disabled:
		button.modulate = Color(0.45, 0.45, 0.45, 0.72)
	elif selected:
		button.modulate = Color(1.0, 0.95, 0.58, 1.0)
	else:
		button.modulate = Color(1.0, 1.0, 1.0, 1.0)
	button.set_pressed_no_signal(selected)

func _texture_region(texture: Texture2D, size: Vector2, vertical_align := REGION_ALIGN_CENTER) -> Rect2:
	var texture_size := Vector2(texture.get_width(), texture.get_height())
	var region_size := Vector2(minf(texture_size.x, size.x), minf(texture_size.y, size.y))
	var offset := (texture_size - region_size) * 0.5
	if vertical_align == REGION_ALIGN_TOP:
		offset.y = 0.0
	elif vertical_align == REGION_ALIGN_BOTTOM:
		offset.y = texture_size.y - region_size.y
	return Rect2(offset, region_size)

func _opaque_bounds(image: Image) -> Rect2i:
	var width := image.get_width()
	var height := image.get_height()
	var data := image.get_data()
	var min_x := width
	var min_y := height
	var max_x := -1
	var max_y := -1

	for y in range(height):
		var row := y * width * 4
		for x in range(width):
			var alpha := data[row + x * 4 + 3]
			if alpha <= 8:
				continue
			min_x = mini(min_x, x)
			min_y = mini(min_y, y)
			max_x = maxi(max_x, x)
			max_y = maxi(max_y, y)

	if max_x < min_x or max_y < min_y:
		return Rect2i(0, 0, width, height)
	return Rect2i(min_x, min_y, max_x - min_x + 1, max_y - min_y + 1)

func _level_bounds(root: Node2D) -> Rect2:
	var rects: Array[Rect2] = []
	_collect_level_rects(root, rects)
	if rects.is_empty():
		return Rect2(Vector2.ZERO, root.get_viewport_rect().size * WORLD_SCALE)

	var bounds := rects[0]
	for i in range(1, rects.size()):
		bounds = bounds.merge(rects[i])
	return bounds

func _collect_level_rects(node: Node, rects: Array[Rect2]) -> void:
	if node is CanvasLayer or node is Camera2D:
		return

	var collision_shape := node as CollisionShape2D
	if collision_shape != null:
		var collision_bounds := _collision_bounds(collision_shape)
		if collision_bounds.size != Vector2.ZERO:
			rects.append(collision_bounds)

	var marker := node as Marker2D
	if marker != null and marker.name == "SpawnPoint":
		var spawn_size := Vector2(SPAWN_GATE.get_width(), SPAWN_GATE.get_height())
		rects.append(Rect2(marker.global_position - spawn_size * 0.5, spawn_size))

	for child in node.get_children():
		_collect_level_rects(child, rects)

func _collision_bounds(collision_shape: CollisionShape2D) -> Rect2:
	if collision_shape.shape == null:
		return Rect2()
	if collision_shape.shape is RectangleShape2D:
		var rectangle := collision_shape.shape as RectangleShape2D
		return Rect2(collision_shape.global_position - rectangle.size * 0.5, rectangle.size)
	return Rect2()

func _collision_size(node: Node) -> Vector2:
	for child in node.get_children():
		var collision_shape := child as CollisionShape2D
		if collision_shape == null or collision_shape.shape == null:
			continue
		if collision_shape.shape is RectangleShape2D:
			return (collision_shape.shape as RectangleShape2D).size
	return Vector2.ZERO

func _polygon_bounds(points: PackedVector2Array) -> Rect2:
	var min_pos := points[0]
	var max_pos := points[0]
	for point in points:
		min_pos = min_pos.min(point)
		max_pos = max_pos.max(point)
	return Rect2(min_pos, max_pos - min_pos)

func _is_hazard_marker(polygon: Polygon2D) -> bool:
	var lower_name := polygon.name.to_lower()
	return lower_name.contains("pit") or lower_name.contains("gap") or lower_name.contains("drop") or lower_name.contains("hazard")
