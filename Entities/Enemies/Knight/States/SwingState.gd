extends GenericState

@export var attacker: CollisionShape2D

func enter(_msg):
	attacker.disabled = false
	await beast.animation_player.animation_finished
	state_machine.change_to_state("IdleState")

func exit():
	# once it's done
	attacker.disabled = true
	beast.random_target_timer.start()
