extends GenericState

@export var leg_target: Node2D
@export var pull_back_time := 1.0
@export var kick_time := 0.5
@export var pull_back: Vector2
@export var kick_goal: Vector2


func enter(_msg):
	beast.random_target_timer.stop()
	attacker.disabled = false

	beast.animation_tree["parameters/LegAction/conditions/kicking"] = true
	beast.animation_tree["parameters/Leg/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	await beast.animation_tree.animation_finished
	
	state_machine.change_to_state("IdleState")

func exit():
	# once it's done
	attacker.disabled = true
	beast.random_target_timer.start()

	beast.animation_tree["parameters/LegAction/conditions/kicking"] = false
