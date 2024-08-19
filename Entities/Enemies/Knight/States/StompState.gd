extends GenericState

@export var stomper: CollisionShape2D

func enter(_msg):
	stomper.disabled = false
	await beast.animation_player.animation_finished
	state_machine.change_to_state("IdleState")

func exit():
	# once it's done
	stomper.disabled = true
	beast.random_target_timer.start()
