extends GenericState

func enter(_msg):
	beast.random_target_timer.stop()
	#print(beast.random_target_timer.is_stopped())

func handle_input(_event):
	pass

func update(_delta):
	pass

func physics_update(_delta):
	pass

func exit():
	pass
