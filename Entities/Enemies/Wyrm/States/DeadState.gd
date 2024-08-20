extends GenericState

@export var head_pointer: Node2D
@export var head_looker: Node2D

@export var death_peak := 30 #subtract from current pos
@export var death_height := 400 #global

func enter(_msg):
	beast.random_target_timer.stop()
	state_machine.on = false
	
	var prev_position = head_pointer.global_position
	
	var tween 
	tween = get_tree().create_tween()
	tween.tween_property(head_pointer, "global_position", prev_position - Vector2(0, death_peak), .5).set_ease(Tween.EASE_IN)
	await tween.finished
	
	tween = get_tree().create_tween()
	tween.tween_property(head_pointer, "global_position", Vector2(0, death_height), .5).set_ease(Tween.EASE_OUT)
	emit_signal("screen_shake")
	
