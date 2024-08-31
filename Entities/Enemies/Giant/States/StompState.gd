extends GenericState

func enter(_msg):
	beast.random_target_timer.stop()
	attacker.disabled = false

	#beast.animation_tree["parameters/LegAction/conditions/kicking"] = false
	beast.animation_tree["parameters/StompType/transition_request"] = "kick"
	beast.animation_tree["parameters/Leg/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	await beast.animation_tree.animation_finished
	
	state_machine.change_to_state("IdleState")

func exit():
	# once it's done
	attacker.disabled = true
	beast.random_target_timer.start()

	#beast.animation_tree["parameters/LegAction/conditions/kicking"] = false
