extends GenericState

@export var arm_target: Node2D

@export var attack_time := 0.4
@export var peak_position := Vector2() # v
@export var attack_position := Vector2() # Going to be a local position

func enter(_msg):
	beast.random_target_timer.stop()
	attacker.disabled = false
	
	beast.animation_tree["parameters/Swinger/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	await beast.animation_tree.animation_finished

	state_machine.change_to_state("IdleState")

func exit():
	# once it's done
	attacker.disabled = true
	beast.random_target_timer.start()
