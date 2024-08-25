extends GenericState

@export var target_x_min = 350
@export var target_x_max = 725

func enter(msg):
	attacker.disabled = false
	beast.random_target_timer.stop()
	beast.acquire_targets()
	
	var target_x = randf_range(target_x_min, target_x_max)
	target_x *= -1
	
	var anim = beast.animation_tree.get_animation("bite")
	var bite_x_track = anim.find_track("IKTargets/headTarget:position:x", Animation.TYPE_VALUE)
	anim.track_remove_key(bite_x_track, 2)
	anim.track_insert_key(bite_x_track, 0.6, target_x)
	
	beast.animation_tree["parameters/Biter/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	await beast.animation_tree.animation_finished
	state_machine.change_to_state(["IdleState", "RoarState"].pick_random())

func exit():
	# exit clean up
	attacker.disabled = true
	#beast.random_target_timer.start()
