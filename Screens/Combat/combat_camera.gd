extends Camera2D

var velocity = Vector2(0,0)

@export var SPEED = 400

var shaking = false

@export var max_zoom = 1.8
@export var min_zoom = 1.0
@export var zoom_scale = 0.05

# Called when the node enters the scene tree for the first time.
func _ready():
	#zoom = Vector2.ONE * 1.5
	pass

var mouse_anchor: Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	zoom = zoom.clampf(min_zoom, max_zoom)
	
	var direction = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	if direction: velocity = direction * SPEED
	else: velocity = velocity.move_toward(Vector2.ZERO, SPEED)

	if Input.is_action_just_pressed("grab_camera"):
		mouse_anchor = get_local_mouse_position()
	if Input.is_action_pressed("grab_camera"):
		#position -= (mouse_anchor - get_local_mouse_position()) / (zoom * 2)
		direction = mouse_anchor.direction_to(get_local_mouse_position())
		velocity = direction * SPEED
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, Vector2(limit_right, limit_bottom) - get_viewport_rect().size / zoom)
	
	if shaking:
		offset = $ShakeTimer.time_left * Vector2(randf_range(-8,8), randf_range(-8,8))

#var dragging := false
#var mouse_anchor: Vector2
func _input(event) -> void:
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#if not dragging and event.pressed:
			#mouse_anchor = event.position
			#dragging = true
		#if dragging and not event.pressed:
			#dragging = false
	#if event is InputEventMouseMotion and dragging:
		#position += (mouse_anchor + event.position)# * zoom

	if event is InputEventMouseButton:
		if event.is_action_pressed("zoom_in"):
			zoom += Vector2.ONE * zoom_scale
			if zoom < Vector2(max_zoom, max_zoom):
				position += zoom * 16
		elif event.is_action_pressed("zoom_out"):
			zoom -= Vector2.ONE * zoom_scale
				#position -= get_viewport_rect().size / 2 * zoom
		

func _on_shake_timer_timeout():
	shaking = false


func shake_screen():
	shaking = true
	$ShakeTimer.start()
