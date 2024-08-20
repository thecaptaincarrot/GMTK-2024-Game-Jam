extends Sprite2D

var time = 0

@export var y_scale = 20
@export var speed_scale = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	offset.y = y_scale*sin(speed_scale * time)
