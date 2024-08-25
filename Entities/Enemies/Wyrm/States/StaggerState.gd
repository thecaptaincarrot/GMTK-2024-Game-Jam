extends GenericState

@export var head_pointer: Node2D

func enter(msg):
	var slam_anim = beast.animation_tree.get_animation("stagger")
	var slam_track = slam_anim.find_track("IKTargets/headTarget:position:x", Animation.TYPE_VALUE)
	var key1 = slam_anim.track_get_key_time(0, 0)
	slam_anim.track_remove_key(0, 0)
	slam_anim.track_insert_key(0, key1, msg, 2.0)
	var key2 = slam_anim.track_get_key_time(0, 1.4)
	slam_anim.track_remove_key(0, key2)
	slam_anim.track_insert_key(0, 1.4, msg)
	await beast.animation_tree.animation_finished
	state_machine.change_to_state("IdleState")


func exit():
	beast.random_target_timer.start()
