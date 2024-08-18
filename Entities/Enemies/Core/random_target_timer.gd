extends Timer

@onready var beast = $".."
var current_retarget_time: float

func _ready():
	_on_timeout()

#func restart_targeting():
	#print("trigger")
	#start(current_retarget_time)


func _on_timeout() -> void:
	current_retarget_time = randf_range(beast.min_retarget_time, beast.max_retarget_time)
	wait_time = current_retarget_time
