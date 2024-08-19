extends GenericState

func target_and_attack():
	var state = ["StompState", "SwingState"].pick_random()
	state_machine.change_to_state(state)

func _on_random_target_timer_timeout() -> void:
	#target_and_attack()
	pass
