extends GenericState

func enter(_msg):
	pass
	#print("dragon")

func handle_input(event):
	if event.is_action_pressed("ui_accept"):
		state_machine.change_to_state("IdleState")
	#pass

#func update(delta):
	#pass

func physics_update(_delta):
	pass

func exit():
	pass
