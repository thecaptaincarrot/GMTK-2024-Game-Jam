extends GenericState

func enter(_msg):
	beast.random_target_timer.stop()
	state_machine.on = false
	await beast.animation_player.animation_finished
	emit_signal("screen_shake")
