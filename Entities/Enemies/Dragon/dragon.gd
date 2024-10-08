extends Node2D

@onready var enemy = $Beast
@export var horde_controller: GooblinHordeController

# these two are kind of hacky but it doesnt really matter since this script is a unique monster sript
@onready var attacker: CollisionShape2D = $Beast/HitboxComponent/Attacker
@onready var head_pointer: Node2D = $Beast/IKTargets/headTarget

@export var roar_into_bite_percent := 25.0
@export var bite_into_roar_percent := 40.0
@export var bite_chance_percent := 40.0 #otherwise stomp


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
	attacker.global_position.x = head_pointer.global_position.x
	
