extends GenericState

@export var undulator: Node2D

func enter(_msg):
	beast.random_target_timer.stop()
	state_machine.on = false
	
	beast.animation_tree.set("parameters/Life/transition_request", "dead")
	#var tween
	#tween = get_tree().create_tween()
	#tween.tween_property(undulator, "global_position", undulator.global_position + Vector2(0, 250), 0.5).set_ease(Tween.EASE_OUT_IN)
