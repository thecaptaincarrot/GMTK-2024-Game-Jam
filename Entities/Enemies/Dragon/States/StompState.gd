extends GenericState

@export var foot_pointer: Node2D

@export var peak = 250
@export var x_peak = 70
@export var wind_up_time := 2.0
@export var hold_time := 2.0
@export var stomp_time := 0.5


func enter(_msg):
	# enable hitbox
	stomper.disabled = false
	# stopped again for good measure
	beast.random_target_timer.stop()
	var prev_foot_pointer_position = foot_pointer.global_position
	
	# animation
	var tween
	tween = get_tree().create_tween()
	tween.tween_property(foot_pointer, "global_position", prev_foot_pointer_position - Vector2(x_peak, peak), wind_up_time).set_ease(Tween.EASE_IN)
	await tween.finished
	
	tween = get_tree().create_tween()
	tween.tween_property(foot_pointer, "global_position", prev_foot_pointer_position - Vector2(x_peak, peak - 10), hold_time).set_trans(Tween.TRANS_EXPO)
	await tween.finished

	tween = get_tree().create_tween()
	tween.tween_property(foot_pointer, "global_position", prev_foot_pointer_position, stomp_time).set_trans(Tween.TRANS_SPRING)
	await tween.finished
	
	flingerize_gooblins()
	emit_signal("screen_shake")
	
	state_machine.change_to_state("IdleState")

# placeholder function. all functions named flingerize_gooblins and hurt_gooblins are placeholder


func physics_update(_delta):
	# the hitbox gets references each frame but hurt_gooblins is called only once
	intersecting_goobs = hitbox.get_overlapping_bodies()

func exit():
	# once it's done, clean up the state by reenabling the hitbox and counting down to attack again
	stomper.disabled = true
	beast.random_target_timer.start()
