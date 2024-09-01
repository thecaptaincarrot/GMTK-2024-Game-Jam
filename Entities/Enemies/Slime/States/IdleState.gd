extends GenericState

@export var sprite_radius = 300
@export var jump_min = 0
@export var jump_max = -2000
var target_position: float

func enter(_msg) -> void:
	beast.random_target_timer.start()
	target_position = randf_range(jump_min + sprite_radius, jump_max - sprite_radius)
	
func target_for_jump():
	#var target_x = randi_range(jump_range_from, jump_range_to)
	if randi_range(1,beast.attack_chance) == 1:
		beast.random_target_timer.stop()
		state_machine.change_to_state("JumpState",target_position)
