extends GenericState

@export var stomper: CollisionShape2D

var damage

func enter(_msg):
	state_machine.change_to_state("IdleState")

func handle_input(_event):
	pass

func update(_delta):
	pass

func physics_update(_delta):
	pass

func exit():
	# once it's done
	beast.random_target_timer.start()
