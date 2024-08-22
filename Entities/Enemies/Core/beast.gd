class_name Beast extends Node2D

##A generic enemy class that can be extended to any enemies added to the game

@onready var state_machine: Node = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var ik_targets: Node2D = $IKTargets
@onready var hitbox_component: Area2D = $HitboxComponent
@onready var skeleton: Skeleton2D = $SkeletonComponent

# Refer to the timer itself
@onready var random_target_timer: Timer = $RandomTargetTimer
# The timer is set by these values instead of it's own wait_time
@export var min_retarget_time := 2.0
@export var max_retarget_time := 4.0

# 1 in X chance to launch the attack it's deliberating on
#(1/1 means guaranteed, 1/2 means coinflip etc)
@export var attack_chance := 1

var dead = false
# i havent really developed the deadstate but it's pretty straightforward i think
# need to make death anims but those are easy since i won't have to account for anything
# just need to stop the timer in the state code and play the death animation
signal died
signal enemy_hurt
signal shake_screen
signal shake_off_scalers

@export var max_health := 1000.0 #placeholder
var health = max_health
@export var blood_color = Color.RED

@export var gold_value = 10000.0 #how much you earn for defeating it
#You earn a weighted percentage of 50% of total for dealing damage

# Universal functionality but customized use in states
signal reacquire_targets
@export var targets := []
var current_target: Gooblin

# used mainly just for slime
signal took_damage

func _ready():
	health = max_health
	state_machine.state_changed.connect(_fsm_state_changed)
	animation_player.animation_finished.connect(_on_animation_finished)
	call_deferred("acquire_targets")
	
	# enable rig only when this node loads in
	# no more pain
	skeleton.get_modification_stack().enabled = true
	# the animation tree too
	animation_tree.active = true

func _fsm_state_changed(state: String):
	# Debug printer
	#prints(owner.name,"is registering that the state changed to", state)
	
	# Delegates finding the animation to the state. Fallback is "universal_idle"
	#if state_machine.find_child(state).animation != "":
		#animation_player.play(state_machine.find_child(state).animation)
	pass

func _on_animation_finished(_anim):
	# never uncomment this line under any circumstance
	#state_machine.change_to_state("IdleState")
	pass

func take_damage(dmg):
	took_damage.emit(dmg)
	health -= dmg
	emit_signal("enemy_hurt")
	if health <= 0:
		die()

func die():
	if !dead:
		died.emit()
		dead = true

func get_lunge_point():
	return $LungePoint

func get_climb_path():
	return $ScalerPath

# acquires the horde controller's basic gooblins by way of parent node
# note: there isn't a specific reason it's basic gooblins only, it was arbitrary
func acquire_targets():
	if owner.get("target_list") == null:
		print("invalid target_list!!!!!")
	else:
		reacquire_targets.emit()
		targets = owner.target_list
		print("target_list valid")


func get_gold_value():
	return gold_value


func _on_state_machine_shake_screen():
	print("Hi")
	emit_signal("shake_screen")


func _on_state_machine_shake_off_scalers(scaler_shakeoff_chance):
	emit_signal("shake_off_scalers",scaler_shakeoff_chance)


# yes i added this again. yes im evil
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		take_damage(100000)
