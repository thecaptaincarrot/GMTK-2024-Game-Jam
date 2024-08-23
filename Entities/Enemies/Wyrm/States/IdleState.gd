extends GenericState

@export var head_pointer: Node2D
@export var reset_pos := Vector2(-672, 600)

@export var slam_min_range := 500

@export var slam_max_range := 700
@export var track_height := 250

func enter(_msg):
# very similar to the dragon code except it goes into StaggerState where it does nothing for a while after attacking
	#beast.animation_tree["parameters/Base/conditions/idling"] = true
	pass
	

func target_and_attack():
	if get("head_pointer"):
		#var tween_target
		var current_target
		var msg = 0
		current_target = randf_range(slam_min_range, slam_max_range)
		#tween_target = beast.global_position + Vector2(-current_target, -track_height)
		#msg = beast.to_global(Vector2(-current_target, 0)).x
		msg = -current_target


		if randi_range(1,beast.attack_chance) == 1:
			print("gonna atack")
			beast.random_target_timer.stop()
			# pass the target gooblin object as the message 
			state_machine.change_to_state("SlamState", msg)
		#head_pointer.set_global_position(beast.current_target.get_global_position())
