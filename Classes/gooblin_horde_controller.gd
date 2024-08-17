extends Node2D

class_name GooblinHordeController

@export var horde_target:Node2D

@export var gooblin_size = Vector2(64, 64)

@export var horde_range = 128

@export var spawn_basic_count = 100

@export var spawn_shield_count = 20

@export var spawn_assassin_count = 0

@export var spawn_catapult_count = 0

@onready var gooblin_scene = preload("res://Entities/Gooblins/gooblin.tscn")


var _basic_gooblins = []

var _shield_gooblins = []

func _ready():
	_setup_horde_rotation_lines()
	randomize()
	for i in range(spawn_basic_count):
		var spawn_pos = get_global_position() + Vector2(randf_range(-32.0, 32.0),randf_range(-32.0, 32.0))
		spawn_basic_gooblin(spawn_pos)
		
	for i in range(spawn_shield_count):
		var spawn_pos = get_global_position() + Vector2(randf_range(-32.0, 32.0),randf_range(-32.0, 32.0))
		spawn_shield_gooblin(spawn_pos)

#this is used the exchange the back lanes for the front
func _setup_horde_rotation_lines():
	var basic_gooblin_timer_rotation = Timer.new()
	basic_gooblin_timer_rotation.timeout.connect(_rotate_out_basic)
	basic_gooblin_timer_rotation.autostart = true
	basic_gooblin_timer_rotation.set_wait_time(1.0)
	add_child(basic_gooblin_timer_rotation)

func _process(delta: float) -> void:
	distribute_target_spacing()

func spawn_basic_gooblin(position:Vector2):
	var goob = gooblin_scene.instantiate()
	goob.set_position(position)
	goob.unit_type = Gooblin.GooblinType.BASIC
	get_parent().call_deferred("add_child", goob)
	_basic_gooblins.append(goob)

func spawn_shield_gooblin(position:Vector2):
	var goob = gooblin_scene.instantiate()
	goob.set_position(position)
	goob.unit_type = Gooblin.GooblinType.SHIELD
	get_parent().call_deferred("add_child", goob)
	_shield_gooblins.append(goob)

func distribute_target_spacing():
	if(horde_target != null):
		for bg in _basic_gooblins:
			bg.enemy_target = horde_target
	
		var bindex = 0
		for bg in _basic_gooblins:
			bg.target_range = horde_range + (((gooblin_size.x / 8) / (_basic_gooblins.size() * .01)) * bindex)
			bg.x_home = horde_target.get_position().x - bg.target_range
			bindex += 1

		for sg in _shield_gooblins:
			sg.enemy_target = horde_target
	
		var sindex = 0
		for sg in _shield_gooblins:
			sg.target_range = horde_range + (((gooblin_size.x / 4)) * sindex)
			sg.x_home = horde_target.get_position().x - sg.target_range
			sindex += 1

func _rotate_out_basic():
	if(_basic_gooblins.size() > 1):
		var goob = _basic_gooblins.pop_front()
		_basic_gooblins.append(goob)
