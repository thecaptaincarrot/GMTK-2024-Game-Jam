extends GenericState

@export var leg_target: Node2D
@export var leg_peak := Vector2(-69, 18)
@export var peak_time := 1.0
@export var stomp_time := 0.2

func enter(_msg):
	beast.random_target_timer.stop()
	stomper.disabled = false
	var prev = leg_target.position
	var tween
	tween = get_tree().create_tween()
	tween.tween_property(leg_target, "position", leg_peak, peak_time).set_trans(Tween.TRANS_SPRING)
	await tween.finished
	
	tween = get_tree().create_tween()
	tween.tween_property(leg_target, "position", prev, stomp_time).set_trans(Tween.TRANS_QUINT)
	await tween.finished
	
	hurt_gooblins()
	emit_signal("screen_shake")
	flingerize_gooblins()
	
	state_machine.change_to_state("IdleState")

func exit():
	# once it's done
	stomper.disabled = true
	beast.random_target_timer.start()
