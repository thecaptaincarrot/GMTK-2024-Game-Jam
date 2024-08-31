extends GenericState

@export var arm_target: Node2D
@export var leg_target: Node2D

# called every timeout on randomtargettimer
func target_and_attack():
	var state = ["StompState", "SwingState", "ActualStompState"].pick_random()
	state_machine.change_to_state(state)
