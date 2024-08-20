extends Node2D


const BASIC = preload("res://Screens/MainMenu/basic_runner.tscn")
const SCALER = preload("res://Screens/MainMenu/shield_runner.tscn")
const SHIELD = preload("res://Screens/MainMenu/scaler_runner.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	$Timer.wait_time = pow(randf_range(0.05,0.5),2.0)
	var dice = randi_range(0,10)
	var new_runner
	if dice < 6:
		new_runner = BASIC.instantiate()
	elif dice <8:
		new_runner = SHIELD.instantiate()
	else:
		new_runner = SCALER.instantiate()
	
	var pos = randf_range(-64,96)
	new_runner.position.y = pos
	new_runner.z_index = round(pos)
	add_child(new_runner)
	
