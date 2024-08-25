extends GenericState

@export var head_pointer: Node2D
@export var head_looker: Node2D

@export var death_peak := 30 #subtract from current pos
@export var death_height := 400 #global

func enter(_msg):
	beast.random_target_timer.stop()
	state_machine.on = false
	beast.animation_tree.set("parameters/Life/transition_request", "dead")
	
