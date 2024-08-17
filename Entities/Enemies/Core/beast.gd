class_name Beast extends CharacterBody2D

##A generic enemy class that can be extended to any enemies added to the game

#An enemy must have at a minimum
#-A 2d rigged skeleton with idle, attack, and kick animations
#-A maximum/current health stat that can be decreased by attacking gooblins
#-A variable size “attack area” that corresponds to its attack or kick animations

var gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var state_machine: Node = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var max_health := 100 #placeholder
var health = max_health

# attackareas dictionary?


# Actual logic
func _ready():
	state_machine.state_changed.connect(_fsm_state_changed)

func _process(_delta):
	pass

func _physics_process(delta: float) -> void:
	#should probably move CHaracterBody2D functionality to the parent
	velocity.y += gravity * delta
	move_and_slide()

func _fsm_state_changed(state):
	#prints(owner.name,"is registering that the state changed to", state)
	animation_player.play(state)

func take_damage(dmg):
	health -= dmg
