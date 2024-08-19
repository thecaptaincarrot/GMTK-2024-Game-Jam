class_name Beast extends Node2D

##A generic enemy class that can be extended to any enemies added to the game

@onready var state_machine: Node = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ik_targets: Node2D = $IKTargets
@onready var hitbox_component: Area2D = $HitboxComponent

# Refer to the timer itself
@onready var random_target_timer: Timer = $RandomTargetTimer
# The timer is set by these values instead of it's own wait_time
@export var min_retarget_time := 2.0
@export var max_retarget_time := 4.0

# 1 in X chance to launch the attack it's deliberating on
#(1/1 means guaranteed, 1/2 means coinflip etc)
@export var attack_chance := 1

# i havent really developed the deadstate but it's pretty straightforward i think
# need to make death anims but those are easy since i won't have to account for anything
# just need to stop the timer in the state code and play the death animation
signal died
@export var max_health := 1000 #placeholder
var health = max_health

# Universal functionality but customized use in states
signal reacquire_targets
@export var targets := []
var current_target: Gooblin

# used mainly just for slime
signal took_damage

func _ready():
	state_machine.state_changed.connect(_fsm_state_changed)
	animation_player.animation_finished.connect(_on_animation_finished)
	call_deferred("acquire_targets")

func _fsm_state_changed(state: String):
	# Debug printer
	#prints(owner.name,"is registering that the state changed to", state)
	
	# Delegates finding the animation to the state. Fallback is universal_idle
	if state_machine.find_child(state).animation != "":
		animation_player.play(state_machine.find_child(state).animation)

func _on_animation_finished(_anim):
	# never uncomment this line under any circumstance
	#state_machine.change_to_state("IdleState")
	pass

func take_damage(dmg):
	took_damage.emit()
	health -= dmg
	if health <= 0:
		die()

func die():
	died.emit()

# acquires the horde controller's basic gooblins by way of parent node
# note: there isn't a specific reason it's basic gooblins only, it was arbitrary
func acquire_targets():
	if owner.get("target_list") == null:
		print("invalid target_list!!!!!")
	else:
		reacquire_targets.emit()
		targets = owner.target_list
		print("target_list valid")

func get_lunge_point():
	return $LungePoint

func get_climb_target():
	return $ScalerPath
