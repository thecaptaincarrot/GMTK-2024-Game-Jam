extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	frame = randi_range(0,6)
	play() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
