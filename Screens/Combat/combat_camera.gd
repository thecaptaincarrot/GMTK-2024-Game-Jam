extends Camera2D

var velocity = Vector2(0,0)

@export var SPEED = 300

var shaking = false

@export var max_zoom = 2.0
@export var min_zoom = 0.5
@export var zoom_scale = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var direction = Input.get_axis("camera_left", "camera_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	direction = Input.get_axis("camera_up", "camera_down")
	if direction:
		velocity.y = direction * SPEED
	else:
		velocity.y = move_toward(velocity.x, 0, SPEED)
	
	position += velocity * delta
	if position.x > limit_right - get_viewport_rect().size.x: position.x = limit_right - get_viewport_rect().size.x #why is this a thing lmao
	if position.y > limit_bottom - get_viewport_rect().size.y: position.y = limit_bottom - get_viewport_rect().size.y #why is this a thing lmao
	
	if position.x < 0: position.x = 0 #why is this a thing lmao
	if position.y < 0: position.y = 0 #why is this a thing lmao
	
	if shaking:
		offset = $ShakeTimer.time_left * Vector2(randf_range(-8,8), randf_range(-8,8))


func _on_shake_timer_timeout():
	shaking = false


func shake_screen():
	shaking = true
	$ShakeTimer.start()
