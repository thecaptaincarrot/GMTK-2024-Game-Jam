extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	apply_impulse(Vector2(randf_range(-.3,.3), -randf_range(.5,1)) * 160.0, Vector2(randf_range(-32,32),0))
	apply_torque_impulse(randf_range(-1000.0,1000.0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
