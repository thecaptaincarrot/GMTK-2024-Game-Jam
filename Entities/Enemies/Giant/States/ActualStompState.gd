extends GenericState

@export var leg_target: Node2D
@export var leg_peak := Vector2(-69, 18)
@export var peak_time := 1.0
@export var stomp_time := 0.2

func enter(_msg):
	beast.random_target_timer.stop()
	stomper.disabled = false

	beast.animation_tree["parameters/LegAction/conditions/stomping"] = true
	beast.animation_tree["parameters/Leg/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	await beast.animation_tree.animation_finished
	
	state_machine.change_to_state("IdleState")

func exit():
	# once it's done
	stomper.disabled = true
	beast.animation_tree["parameters/LegAction/conditions/stomping"] = false
	beast.random_target_timer.start()
