extends GenericState

@export var head_pointer: Node2D

@export var stomp_range := 500

@export var bite_max_range := 700
@export var track_height := 250

#func enter(_msg):
	#pass
	#print("dragon")

#func handle_input(event):
	#pass

#func update(_delta):
	#pass

#func physics_update(_delta):
	#pass

#func exit():
	#pass

var tween

func target_and_attack():
	if get("head_pointer"):
		var tween_target
		var state_target
		#var current_target = beast.targets.pick_random()
		var current_target
		var msg = 0
		var attack_to_do = 0 #randi_range(0,2)
		match attack_to_do:
			0:
				current_target = randf_range(stomp_range, bite_max_range)
				tween_target = beast.global_position + Vector2(-current_target, -track_height)
				state_target = "BiteState"
				printt(current_target,tween_target)
			1:
				tween_target = beast.to_global(Vector2(-585, -338))
				state_target = "StompState"
			2:
				return
		tween = get_tree().create_tween()
		tween.tween_property(head_pointer,"global_position" , tween_target, beast.random_target_timer.wait_time).set_trans(Tween.TRANS_SINE)
		await tween.finished
		if randi_range(1,beast.attack_chance) == 1:
			print("gonna atack")
			beast.random_target_timer.stop()
			# pass the target gooblin object as the message 
			state_machine.change_to_state(state_target, msg)
		#head_pointer.set_global_position(beast.current_target.get_global_position())
