class_name Beast extends CharacterBody2D

##A generic enemy class that can be extended to any enemies added to the game

#An enemy must have at a minimum
#-A 2d rigged skeleton with idle, attack, and kick animations
#-A maximum/current health stat that can be decreased by attacking gooblins
#-A variable size “attack area” that corresponds to its attack or kick animations

@onready var state_machine = $StateMachine

@export var health := 100 #placeholder value

var gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")

# Actual logic
func _ready():
	state_machine.state_changed.connect(fsm_state_changed)

func _process(_delta):
	pass

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	move_and_slide()

func fsm_state_changed(state):
	prints("the enemy is registering that the state changed to", state)
