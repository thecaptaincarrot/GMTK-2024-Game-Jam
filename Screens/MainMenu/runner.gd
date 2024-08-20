extends AnimatedSprite2D

@export var run_speed = 150

var is_visible = false
# Called when the node enters the scene tree for the first time.
func _ready():
	play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += run_speed * delta
	if position.x > get_viewport_rect().size.x + 200:
		queue_free()
