extends GenericState

@export var arm_target: Node2D
@export var leg_target: Node2D

func enter(_msg):
	var tween
	tween = get_tree().create_tween()
	tween.tween_property(arm_target, "position", Vector2(-83, 69), 1.0).set_trans(Tween.TRANS_SPRING)
	
	var tween2
	tween2 = get_tree().create_tween()
	tween2.tween_property(leg_target, "position", Vector2(-19, 98), 1.0).set_trans(Tween.TRANS_SPRING)



func target_and_attack():
	var state = ["StompState", "SwingState"].pick_random()
	state_machine.change_to_state(state)
