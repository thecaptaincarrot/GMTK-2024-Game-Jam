extends GenericState

func enter(_msg):
	beast.random_target_timer.stop()
	stomper.disabled = false

	beast.animation_tree["parameters/StompType/transition_request"] = "actualstomp"
	beast.animation_tree["parameters/Leg/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	await beast.animation_tree.animation_finished
	
	state_machine.change_to_state("IdleState")

func exit():
	# once it's done
	stomper.disabled = true
	#beast.animation_tree["parameters/LegAction/conditions/kicking"] = false
	beast.random_target_timer.start()
