extends GenericState

func enter(_msg):
	beast.random_target_timer.start()


	beast.random_target_timer.stop()
	print("gonna attack")
	var state = ["StompState", "SwingState"].pick_random()
	#print(beast.animation_tree)
	state_machine.change_to_state(state)
