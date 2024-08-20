extends GenericState

@export var head_pointer: Node2D

@export var stomp_range := 500

@export var bite_max_range := 700
@export var track_height := 250

var tween


# this function is connected to the timeout of the randomtarget timer (most IdleStates do this)
# the attack_to_do picks what to deliberate. 0 is bite, 1 is stomp, 2 is nothing
# further along the function, there's another check with attack_chance that decides if the dragon will do
#what it is deliberating on and swaps into the appropriate state if it chooses to
func target_and_attack():
	if get("head_pointer"):
		var tween_target
		var state_target
		#var current_target = beast.targets.pick_random()
		var current_target
		var msg = 0
		var attack_to_do = randi_range(0,100)
		if attack_to_do < 40:
			attack_to_do = 0
		elif attack_to_do < 80:
			attack_to_do = 1
		else:
			attack_to_do = 2
		print(attack_to_do)
		match attack_to_do:
			0:
				current_target = randf_range(stomp_range, bite_max_range)
				tween_target = beast.global_position + Vector2(-current_target, -track_height)
				state_target = "BiteState"
				# the generated target x position is turned into global for the bite to go to
				msg = beast.to_global(Vector2(-current_target, 0)).x
				#printt(current_target,tween_target)
			1:
				tween_target = [beast.global_position + Vector2(randf_range(stomp_range, bite_max_range),-track_height), beast.to_global(Vector2(-585, -338))].pick_random()
				state_target = "StompState"
			2:
				current_target = randf_range(stomp_range, bite_max_range)
				tween_target = beast.global_position + Vector2(-current_target, -track_height)
		tween = get_tree().create_tween()
		tween.tween_property(head_pointer,"global_position" , tween_target, beast.random_target_timer.wait_time).set_trans(Tween.TRANS_SINE)
		await tween.finished
		if randi_range(1,beast.attack_chance) == 1 and state_target:
			print("gonna atack")
			# if it is going to attack, you shouldn't start the timer until after the attack is done
			beast.random_target_timer.stop()
			# pass the target x coordinate as the message 
			state_machine.change_to_state(state_target, msg)
