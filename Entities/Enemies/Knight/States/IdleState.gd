extends GenericState

func enter(_msg):
	beast.animation_tree.set("parameters/Base/conditions/idling", true)

func exit():
	beast.animation_tree.set("parameters/Base/conditions/idling", false)

func target_and_attack():
	print("gonna attack")
	var state = ["StompState", "SwingState"].pick_random()
	print(beast.animation_tree)
	state_machine.change_to_state(state)
