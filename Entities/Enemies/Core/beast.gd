class_name Beast extends Node2D

##A generic enemy class that can be extended to any enemies added to the game

#An enemy must have at a minimum
#-A 2d rigged skeleton with idle, attack, and kick animations
#-A maximum/current health stat that can be decreased by attacking gooblins
#-A variable size “attack area” that corresponds to its attack or kick animations

@onready var state_machine: Node = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ik_targets: Node2D = $IKTargets

@onready var random_target_timer: Timer = $RandomTargetTimer

@export var min_retarget_time := 2
@export var max_retarget_time := 4
var current_retarget_time := 3.0

signal attack_call(target)

@export var max_health := 100 #placeholder
var health = max_health

signal target_changed(target)

@export var targets := []
var current_target: Gooblin

# Actual logic
func _ready():
	state_machine.state_changed.connect(_fsm_state_changed)
	animation_player.animation_finished.connect(_on_animation_finished)
	call_deferred("acquire_targets", owner)
	current_retarget_time = randf_range(min_retarget_time, max_retarget_time)

func _fsm_state_changed(state: String):
	# Debug printer
	#prints(owner.name,"is registering that the state changed to", state)
	
	# Delegates finding the animation to the state. Fallback is universal_idle
	animation_player.play(state_machine.find_child(state).animation)

func _on_animation_finished(_anim):
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
	current_retarget_time = randf_range(min_retarget_time, max_retarget_time)
	current_target = targets.pick_random()
	target_changed.emit(current_target)
	if randi_range(1,3) == 1 and current_target:
		random_target_timer.stop()
		attack_call.emit(current_target)

func restart_targeting():
	random_target_timer.start(current_retarget_time)
