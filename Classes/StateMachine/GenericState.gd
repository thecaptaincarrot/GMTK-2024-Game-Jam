class_name GenericState extends Node

## This state acts as reference to set up the state you're working on
# Add states as children to the StateMachine node

# Reference to FSM added so you can swap between states from inside the state
@onready var state_machine = $".."

# Reference to the stats of the enemy in question
@onready var beast: Beast = state_machine.get_parent()

# The animation is an export variable !!!
@export var animation: String = "universal_idle"

func enter(_msg):
	pass

func handle_input(_event):
	pass

func update(_delta):
	pass

func physics_update(_delta):
	pass

func exit():
	pass
