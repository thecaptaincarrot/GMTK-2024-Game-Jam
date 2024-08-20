extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	apply_central_impulse(Vector2(randf_range(-.3,.3), -randf_range(.5,1)) * 500)
	apply_torque_impulse(randf_range(-100.0,100.0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
