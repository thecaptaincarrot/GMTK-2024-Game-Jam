extends GenericState

@export var head_pointer: Node2D
@export var lying_time := 3

func enter(msg):
	var slam_anim = beast.animation_tree.get_animation("stagger")
	slam_anim.track_remove_key(0, 0)
	slam_anim.bezier_track_insert_key(0, 1.4, msg)
	await beast.animation_tree.animation_finished
	state_machine.change_to_state("IdleState")


func exit():
	beast.random_target_timer.start()
