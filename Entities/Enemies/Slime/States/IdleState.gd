extends GenericState

@export var sprite_radius = 300
@export var jump_min = 0
@export var jump_max = -2000
@export var first_jump_target := -750.0
var target_position: float
var first_jump_done := false

#func _ready() -> void:
	#beast.position = Vector2(target_position, -87)z

func enter(_msg) -> void:
	beast.random_target_timer.start()
	if not first_jump_done:
		target_position = first_jump_target
		first_jump_done = true
	else:
		target_position = randf_range(jump_min + sprite_radius, jump_max - sprite_radius)

func target_for_jump():
	#var target_x = randi_range(jump_range_from, jump_range_to)
	if randi_range(1,beast.attack_chance) == 1:
		beast.random_target_timer.stop()
		
		var jump_anim = beast.animation_tree.get_animation("jump_slime")
		var beast_x = jump_anim.find_track(".:position:x", Animation.TYPE_VALUE)
		jump_anim.track_remove_key(beast_x, 0)
		jump_anim.track_insert_key(beast_x, 0, beast.position.x)
		
		state_machine.change_to_state("JumpState",target_position)
