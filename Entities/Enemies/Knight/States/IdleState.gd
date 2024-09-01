extends GenericState

func enter(_msg):
	beast.random_target_timer.start()

func target_and_attack():
	var state = ["StompState", "SwingState"].pick_random()
	#var state = ["StompState"].pick_random()
	#print(beast.animation_tree)
	state_machine.change_to_state(state)

func exit():
	beast.random_target_timer.stop()
