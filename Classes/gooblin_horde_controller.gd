extends Node2D

class_name GooblinHordeController

signal gooblin_extinction

#references
@export var gooblin_label : Label

@export var enemy_node:Node2D

@export var horde_target:Node2D

@export var climb_target:Path2D

@export var gooblin_size = Vector2(64, 64)

@export var horde_range = 128

@export var spawn_basic_count = 100

@export var spawn_shield_count = 20

@export var spawn_scaler_count = 0

@export var spawn_catapult_count = 0

@export var rotation_rate = 1.0

@onready var gooblin_scene = preload("res://Entities/Gooblins/gooblin.tscn")


var _basic_gooblins = []

var _shield_gooblins = []

var _scaler_gooblins = []

var active = false

var gooblins_alive = true

func _ready():
	randomize()


func end_level():
	active = false
	for n in get_children():
		if n.name != "SpawnPoint":
			n.queue_free()
	enemy_node = null
	horde_target = null
	climb_target = null


func reset():
	active = true
	randomize()
	spawn_basic_count = GooblinUpgrades.basic_gooblins
	spawn_shield_count = GooblinUpgrades.shield_gooblins
	spawn_scaler_count = GooblinUpgrades.climb_gooblins
	print(spawn_basic_count)
	_setup_horde_rotation_lines()
	spawn_gooblins()


func spawn_gooblins():
	for i in range(spawn_basic_count):
		var spawn_pos = get_spawn_point() + Vector2(randf_range(-32.0, 32.0),randf_range(-32.0, 32.0))
		spawn_basic_gooblin(spawn_pos)
		
	for i in range(spawn_shield_count):
		var spawn_pos = get_spawn_point() + Vector2(randf_range(-32.0, 32.0),randf_range(-32.0, 32.0))
		spawn_shield_gooblin(spawn_pos)
	
	for i in range(spawn_scaler_count):
		var spawn_pos = get_spawn_point() + Vector2(randf_range(-32.0, 32.0),randf_range(-32.0, 32.0))
		spawn_scaler_gooblin(spawn_pos)


func kill_all():
	print(len(_basic_gooblins))
	var kill_list = _basic_gooblins.duplicate()
	for gooblin in kill_list:
		gooblin.die()
	kill_list = _scaler_gooblins.duplicate()
	for gooblin in kill_list:
		gooblin.die()
	kill_list = _shield_gooblins.duplicate()
	for gooblin in kill_list:
		gooblin.die()
	


#this is used the exchange the back lanes for the front
func _setup_horde_rotation_lines():
	var basic_gooblin_timer_rotation = Timer.new()
	basic_gooblin_timer_rotation.timeout.connect(_rotate_out_basic)
	basic_gooblin_timer_rotation.autostart = true
	basic_gooblin_timer_rotation.set_wait_time(rotation_rate)
	add_child(basic_gooblin_timer_rotation)


func _process(delta: float) -> void:
	if active:
		distribute_target_spacing()
		gooblin_label.text = str(get_living_gooblins())
		if gooblins_alive:
			if get_living_gooblins() <= 0:
				gooblins_alive = false
				emit_signal("gooblin_extinction")


func get_living_gooblins():
	var number_gooblins = len(get_scaler_gooblins()) + len(get_basic_gooblins()) + len(get_shield_gooblins())
	return number_gooblins


func spawn_basic_gooblin(position:Vector2):
	var goob = gooblin_scene.instantiate()
	goob.set_position(position)
	goob.unit_type = Gooblin.GooblinType.BASIC
	add_child(goob)
	goob.enemy_node = enemy_node
	goob.died.connect(_basic_gooblin_died)
	goob.gooblin_changed.connect(_on_gooblin_changed)
	_basic_gooblins.append(goob)


func spawn_shield_gooblin(position:Vector2):
	var goob = gooblin_scene.instantiate()
	goob.set_position(position)
	goob.unit_type = Gooblin.GooblinType.SHIELD
	add_child(goob)
	goob.enemy_node = enemy_node
	goob.gooblin_changed.connect(_on_gooblin_changed)
	goob.died.connect(_shield_gooblin_died)
	_shield_gooblins.append(goob)


func spawn_scaler_gooblin(position:Vector2):
	var goob = gooblin_scene.instantiate()
	var follower = PathFollow2D.new()
	follower.loop = false
	climb_target.add_child(follower)
	goob.set_position(position)
	goob.path_follower = follower
	goob.unit_type = Gooblin.GooblinType.SCALER
	add_child(goob)
	goob.enemy_node = enemy_node
	goob.gooblin_changed.connect(_on_gooblin_changed)
	goob.died.connect(_scaler_gooblin_died)
	_scaler_gooblins.append(goob)


func distribute_target_spacing():
	if(horde_target != null):
		for bg in _basic_gooblins:
			bg.enemy_target = horde_target
	
		var bindex = 0
		for bg in _basic_gooblins:
			bg.target_range = horde_range + (((gooblin_size.x / 2)) * bindex)
			bg.x_home = horde_target.get_global_position().x - bg.target_range
			bindex += 1

		for sg in _shield_gooblins:
			sg.enemy_target = horde_target
	
		var sindex = 0
		for sg in _shield_gooblins:
			sg.target_range = horde_range + (((gooblin_size.x / 4)) * sindex)
			sg.x_home = horde_target.get_global_position().x - sg.target_range
			sindex += 1


func _rotate_out_basic():
	if(_basic_gooblins.size() > 15):
		var goob = _basic_gooblins.pop_front()
		_basic_gooblins.insert(5, goob)


func _basic_gooblin_died(gooblin):
	if(_basic_gooblins.has(gooblin)):
		_basic_gooblins.erase(gooblin)


func _shield_gooblin_died(gooblin):
	if(_shield_gooblins.has(gooblin)):
		_shield_gooblins.erase(gooblin)


func _scaler_gooblin_died(gooblin):
	if(_scaler_gooblins.has(gooblin)):
		_scaler_gooblins.erase(gooblin)


func _on_gooblin_changed(from_type, to_type, gooblin):
	if(from_type == Gooblin.GooblinType.SHIELD && to_type == Gooblin.GooblinType.BASIC):
		if(_shield_gooblins.has(gooblin)):
			_shield_gooblins.erase(gooblin)
			#push it to the front to they run up to the front line
			_basic_gooblins.push_front(gooblin)


func get_basic_gooblins():
	return _basic_gooblins


func get_shield_gooblins():
	return _shield_gooblins


func get_scaler_gooblins():
	return _scaler_gooblins


func get_spawn_point():
	return $SpawnPoint.global_position
