extends GenericState

@export var head_pointer: Node2D

@export var slam_min_range := 500

@export var slam_max_range := 700
@export var track_height := 250

var tween

func target_and_attack():
	if get("head_pointer"):
		var tween_target
		var current_target
		var msg = 0
		current_target = randf_range(slam_min_range, slam_max_range)
		tween_target = beast.global_position + Vector2(-current_target, -track_height)
		msg = beast.to_global(Vector2(-current_target, 0)).x

		tween = get_tree().create_tween()
		tween.tween_property(head_pointer,"global_position" , tween_target, beast.random_target_timer.wait_time).set_trans(Tween.TRANS_SINE)
		await tween.finished
		if randi_range(1,beast.attack_chance) == 1:
			print("gonna atack")
			beast.random_target_timer.stop()
			# pass the target gooblin object as the message 
			state_machine.change_to_state("SlamState", msg)
		#head_pointer.set_global_position(beast.current_target.get_global_position())
