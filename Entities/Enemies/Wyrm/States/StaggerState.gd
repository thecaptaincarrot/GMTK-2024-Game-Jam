extends GenericState

@export var head_pointer: Node2D
@export var lying_time := 3

func enter(msg):
	var timer = get_tree().create_timer(lying_time)
	await timer.timeout
	var tween
	tween = get_tree().create_tween()
	# retrieve previous position (msg[0]) and get up time (msg[1]) to get up
	tween.tween_property(head_pointer, "global_position", msg[0], msg[1]/1.5).set_trans(Tween.TRANS_EXPO)
	await tween.finished
	state_machine.change_to_state("IdleState")


func exit():
	beast.random_target_timer.start()
