extends Node2D

@onready var enemy = $Beast
@onready var animation_player: AnimationPlayer = $Beast/AnimationPlayer
@export var horde_controller: GooblinHordeController

@onready var attacker: CollisionShape2D = $Beast/HitboxComponent/Attacker
@onready var arm_target: Node2D = $Beast/IKTargets/armTarget

var target_list: Array

func _ready() -> void:
	enemy.reacquire_targets.connect(reacquire_targets)
	reacquire_targets()
	enemy.died.connect(die)
	
func reacquire_targets():
	target_list = horde_controller.get_basic_gooblins()

func die():
	enemy.state_machine.change_to_state("DeadState")

# Surface level dmg function for the horde to access
func take_damage(dmg):
	enemy.take_damage(dmg)


# the hitbox slider
func _process(_delta: float) -> void:
	attacker.global_position.x = arm_target.global_position.x - 65
