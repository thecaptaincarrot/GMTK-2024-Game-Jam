extends Node2D

@onready var enemy = $Beast
@onready var animation_player: AnimationPlayer = $Beast/AnimationPlayer
@export var horde_controller: GooblinHordeController
var target_list: Array

@export var scaler_path : Path2D
@export var sprite_box : Node2D

func _ready() -> void:
	enemy.reacquire_targets.connect(reacquire_targets)
	reacquire_targets()
	enemy.died.connect(die)


func _physics_process(delta):
	update_scaler_path()


func reacquire_targets():
	target_list = horde_controller.get_basic_gooblins()

func die():
	enemy.state_machine.change_to_state("DeadState")

# Surface level dmg function for the horde to access
func take_damage(dmg):
	enemy.take_damage(dmg)


func update_scaler_path():
	for i in range(1,scaler_path.curve.point_count):
		scaler_path.curve.set_point_position(i,sprite_box.get_node("neck" + str(i)).position)
