extends Node2D

@onready var enemy = $Beast
@export var horde_controller: GooblinHordeController
var target_list: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if horde_controller:
		target_list = horde_controller.get_basic_gooblins()
	else:
		print("no horde controller configured for enemy!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _unhandled_key_input(event: InputEvent) -> void:
	# this is getting deleted asap
	if event.is_action_pressed("ui_cancel"):
		enemy.state_machine.change_to_state("StompState")
