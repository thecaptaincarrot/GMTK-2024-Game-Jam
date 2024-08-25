extends GenericState

func enter(_msg):
	beast.random_target_timer.stop()
	attacker.disabled = false
	beast.animation_tree.set("parameters/Swinger/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	await beast.animation_tree.animation_finished
	print("finito")
	#shake_off_scalers()
	state_machine.change_to_state("IdleState")

func exit():
	# once it's done
	attacker.disabled = true
	beast.random_target_timer.start()
