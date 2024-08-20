extends Node2D

@onready var enemy = $Beast
@onready var animation_player: AnimationPlayer = $Beast/AnimationPlayer
@onready var skeleton: Skeleton2D = $Beast/SkeletonComponent

@export var horde_controller: GooblinHordeController


var target_list: Array

@export var bullit_number := 4
var damage_taken = 0
@export var projectile_damage_threshold = 20.0
var bullit = preload("res://Entities/Enemies/Slime/projectile.tscn")

func _ready() -> void:
	enemy.reacquire_targets.connect(reacquire_targets)
	reacquire_targets()
	enemy.died.connect(die)

	enemy.took_damage.connect(_spawn_bullits)
	
	#var timer = get_tree().create_timer(1)
	#await timer.timeout
	skeleton.get_modification_stack().enabled = true

func reacquire_targets():
	target_list = horde_controller.get_basic_gooblins()

func die():
	enemy.state_machine.change_to_state("DeadState")

# Surface level dmg function for the horde to access
func take_damage(dmg):
	enemy.take_damage(dmg)
	
func _spawn_bullits(dmg):
	damage_taken += dmg
	var counter =  0
	if damage_taken >= projectile_damage_threshold:
		damage_taken = 0
		counter =  randi_range(1,bullit_number)
	
	while counter > 0:
		var bul = bullit.instantiate()
		bul.global_position = global_position
		get_parent().add_child(bul)
		counter -= 1


# getting deleted asap, debug function
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		enemy.take_damage(1)
