extends GenericState

func enter(_msg):
	pass

func handle_input(_event):
	pass

func update(_delta):
	pass

func physics_update(_delta):
	pass

func exit():
	beast.current_target.hurt(2)
	# once it's done
	beast.restart_targeting()
