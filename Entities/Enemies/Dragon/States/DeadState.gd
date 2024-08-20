extends GenericState

@export var head_pointer: Node2D
@export var head_looker: Node2D
@export var jaw_looker: Node2D

func enter(_msg):
	beast.random_target_timer.stop()
	state_machine.on = false
	var tween
	tween = get_tree().create_tween()
	tween.tween_property(jaw_looker, "position", Vector2(0, 300), 0.5).set_trans(Tween.TRANS_SPRING)
	await beast.animation_player.animation_finished
	emit_signal("screen_shake")
