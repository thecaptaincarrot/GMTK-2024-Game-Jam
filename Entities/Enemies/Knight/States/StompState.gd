extends GenericState


func enter(_msg):
	beast.random_target_timer.stop()
	stomper.disabled = false
	#beast.animation_tree.set("parameters/conditions/kick", true)
	beast.animation_tree.set("parameters/Stomper/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	#beast.animation_tree.set("parameters/conditions/kick", false)
	await beast.animation_tree.animation_finished
	state_machine.change_to_state("IdleState")


func exit():
	# once it's done
	stomper.disabled = true
	beast.random_target_timer.start()
