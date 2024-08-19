extends GenericState

func target_and_attack():
	print("gonna attack")
	var state = ["StompState", "SwingState"].pick_random()
	
	state_machine.change_to_state(state)
