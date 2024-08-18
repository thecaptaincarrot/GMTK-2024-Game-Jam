class_name Beast extends Node2D

##A generic enemy class that can be extended to any enemies added to the game

#An enemy must have at a minimum
#-A 2d rigged skeleton with idle, attack, and kick animations
#-A maximum/current health stat that can be decreased by attacking gooblins
#-A variable size “attack area” that corresponds to its attack or kick animations

@onready var state_machine: Node = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var max_health := 100 #placeholder
var health = max_health

@export var targets := []

# Actual logic
func _ready():
	state_machine.state_changed.connect(_fsm_state_changed)
	animation_player.animation_finished.connect(_on_animation_finished)
	call_deferred("acquire_targets", owner)

func _fsm_state_changed(state: String):
	# Debug printer
	#prints(owner.name,"is registering that the state changed to", state)
	
	# Delegates finding the animation to the state. Fallback is universal_idle
	animation_player.play(state_machine.find_child(state).animation)

func _on_animation_finished(anim):
	state_machine.change_to_state("IdleState")

func take_damage(dmg):
	health -= dmg
	if health <= 0:
		die()

func die():
	state_machine.change_to_state("DeadState")

func acquire_targets(source: Node2D):
	if source.get("target_list") == null:
		print("invalid target_list!!!!!")
	else:
		targets = source.target_list
		print("target_list valid")


func _on_random_target_timer_timeout() -> void:
	pass
