extends Node2D

@onready var enemy = $Beast
@onready var animation_player: AnimationPlayer = $Beast/AnimationPlayer
@onready var skeleton = $Beast/SkeletonComponent
@export var horde_controller: GooblinHordeController
var target_list: Array

@export var projectile_spawn_offset = Vector2(0,-140)

@export var bullit_number := 4
var damage_taken = 0
@export var projectile_damage_threshold = 20.0
var bullit = preload("res://Entities/Enemies/Slime/projectile.tscn")
var can_bullit = true

@export var projectile_cooldown := 0.2

func _ready() -> void:
	enemy.reacquire_targets.connect(reacquire_targets)
	reacquire_targets()
	enemy.died.connect(die)

	enemy.took_damage.connect(_spawn_bullits)

func reacquire_targets():
	target_list = horde_controller.get_basic_gooblins()


func die():
	enemy.state_machine.change_to_state("DeadState")

# Surface level dmg function for the horde to access
func take_damage(dmg):
	enemy.take_damage(dmg)
	
func _spawn_bullits(dmg):
	if can_bullit:
		damage_taken += dmg
		var counter =  0
		if damage_taken >= projectile_damage_threshold:
			damage_taken = 0
			counter =  randi_range(2,bullit_number)
		
		while counter > 0:
			var bul = bullit.instantiate()
			bul.global_position = enemy.global_position + projectile_spawn_offset
			get_parent().add_child(bul)
			counter -= 1
	can_bullit = false
	var timer = get_tree().create_timer(projectile_cooldown)
	await timer.timeout
	can_bullit = true
