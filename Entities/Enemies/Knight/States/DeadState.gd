extends GenericState

func enter(_msg):
	beast.random_target_timer.stop()
	state_machine.on = false
