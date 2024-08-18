extends Node2D

@onready var enemy = $Beast
@export var horde_controller: GooblinHordeController
@onready var attacker: CollisionShape2D = $Beast/HitboxComponent/Attacker
@onready var head_pointer: Node2D = $Beast/IKTargets/headTarget
var target_list: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy.reacquire_targets.connect(reacquire_targets)
	reacquire_targets()

	enemy.died.connect(die)

func reacquire_targets():
	target_list = horde_controller.get_basic_gooblins()

func die():
	enemy.state_machine.change_to_state("DeadState")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	attacker.global_position.x = head_pointer.global_position.x

func take_damage(dmg):
	enemy.take_damage(dmg)

#func _unhandled_key_input(event: InputEvent) -> void:
	## this is getting deleted asap
	#if event.is_action_pressed("ui_cancel"):
		#enemy.state_machine.change_to_state("StompState")
