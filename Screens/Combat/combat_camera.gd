extends Camera2D

var velocity = Vector2(0,0)

@export var SPEED = 400

var shaking = false

@export var max_zoom = 1.8
@export var min_zoom = 1.0
@export var zoom_scale = 0.05

@export var instructions: Container
var moved_once := false:
	set(val):
		moved_once = val
		if moved_once: try_to_fade_instructions_out()
var zoomed_once := false:
	set(val):
		zoomed_once = val
		if zoomed_once: try_to_fade_instructions_out()

func try_to_fade_instructions_out():
	if moved_once and zoomed_once:
		var tween = get_tree().create_tween()
		tween.tween_property(instructions, "modulate", Color.TRANSPARENT, 3.0)

var mouse_anchor: Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var direction = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	if direction:
		velocity = direction * SPEED
		if not moved_once: moved_once = true
	else: velocity = velocity.move_toward(Vector2.ZERO, SPEED)
	
	#if Input.is_action_just_pressed("grab_camera"):
		#mouse_anchor = get_local_mouse_position()
	#if Input.is_action_pressed("grab_camera"):
		#direction = mouse_anchor.direction_to(get_local_mouse_position())
		#velocity = direction * SPEED
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, Vector2(limit_right, limit_bottom) - get_viewport_rect().size / zoom)
	
	if shaking:
		offset = $ShakeTimer.time_left * Vector2(randf_range(-8,8), randf_range(-8,8))

#var dragging := false
#var mouse_anchor: Vector2

var touch_points := {}
var start_dist : int = 0
var start_zoom := Vector2.ZERO

func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#if not dragging and event.pressed:
			#mouse_anchor = event.position
			#dragging = true
		#if dragging and not event.pressed:
			#dragging = false
	#if event is InputEventMouseMotion and dragging:
		#position += (mouse_anchor + event.position)# * zoom
	if Input.is_action_pressed("grab_camera"):
		if event is InputEventMouseMotion:
			position -= event.relative
			if not moved_once: moved_once = true

	if event is InputEventMouseButton:
		if event.is_action_pressed("zoom_in"):
			zoom += Vector2.ONE * zoom_scale
			if zoom < Vector2(max_zoom, max_zoom):
				position += zoom * 16
		elif event.is_action_pressed("zoom_out"):
			zoom -= Vector2.ONE * zoom_scale
			if not zoomed_once: zoomed_once = true
				#position -= get_viewport_rect().size / 2 * zoom
				
		zoom = zoom.clampf(min_zoom, max_zoom)
	if event is InputEventScreenTouch:
		if event.pressed:
			touch_points[event.index] = event.position
		else:
			touch_points.erase(event.index)
		
		if touch_points.size() == 2:
			var touch_point_positions = touch_points.values()
			start_dist = touch_point_positions[0].distance_to(touch_point_positions[1])
			start_zoom = zoom
			start_dist = 0
	
	if event is InputEventScreenDrag:
		touch_points[event.index] = event.position
		
		if touch_points.size() == 2:
			var touch_point_positions = touch_points.values()
			var current_dist = touch_point_positions[0].distance_to(touch_point_positions[1])
			var zoom_factor = start_dist / current_dist
			zoom = start_zoom / zoom_factor
			zoom = zoom.clampf(min_zoom, max_zoom)
			if not zoomed_once: zoomed_once = true

func _on_shake_timer_timeout():
	shaking = false


func shake_screen():
	shaking = true
	$ShakeTimer.start()
