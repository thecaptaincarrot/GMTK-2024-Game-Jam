extends GenericState

func enter(_msg):
	beast.random_target_timer.stop()
	state_machine.on = false
	beast.animation_tree.set("parameters/Base/conditions/idling", false)
	beast.animation_tree.set("parameters/Base/conditions/walking", false)
	beast.animation_tree.set("parameters/Base/conditions/die", true)
