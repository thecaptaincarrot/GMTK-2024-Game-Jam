extends GenericState

# empty for now
func enter(_msg):
	#beast.random_target_timer.stop()
	var timer = get_tree().create_timer(randf_range(0.9,1.5))
	beast.animation_tree["parameters/Roarer/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	await timer.timeout
	#await beast.random_target_timer.timeout
	beast.animation_tree["parameters/Roarer/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT
	#await beast.animation_tree.animation_finished
	state_machine.change_to_state(["BiteState", "IdleState"].pick_random())
	
#func exit():
	#beast.random_target_timer.stop()
