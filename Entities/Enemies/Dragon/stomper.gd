extends Timer

#scrapped beast child

@onready var enemy = get_parent()
@onready var dragon = enemy.get_parent()

var current_retarget_time

func _ready():
	call_deferred("_on_timeout")

func _on_timeout() -> void:
	current_retarget_time = randf_range(dragon.min_stomp_time, dragon.max_stomp_time)
	wait_time = current_retarget_time
	start(wait_time)
	stomp()

func stomp():
	stop()
	if enemy.dead == false:
		enemy.animation_tree["parameters/Stomper/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
		var finished = await enemy.animation_tree.animation_finished
		if finished == "bite":
			await enemy.animation_tree.animation_finished
			stomp()
		elif finished == "stomp":
			start()
