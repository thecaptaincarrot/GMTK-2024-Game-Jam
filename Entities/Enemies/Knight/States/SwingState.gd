extends GenericState

func enter(_msg):
	beast.random_target_timer.stop()
	attacker.disabled = false
	await beast.animation_player.animation_finished
	shake_off_scalers()
	state_machine.change_to_state("IdleState")


func exit():
	# once it's done
	attacker.disabled = true
	beast.random_target_timer.start()
