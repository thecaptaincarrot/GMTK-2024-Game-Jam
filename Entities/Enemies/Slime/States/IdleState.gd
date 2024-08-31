extends GenericState
#
#@export var jump_range_from := 0 # global
#@export var jump_range_to := -2000 #global again

func enter(_msg) -> void:
	beast.random_target_timer.start()

func target_for_jump():
	#var target_x = randi_range(jump_range_from, jump_range_to)
	if randi_range(1,beast.attack_chance) == 1:
		beast.random_target_timer.stop()
		state_machine.change_to_state("JumpState")
