extends CharacterBody2D

class_name Gooblin

@export var max_health = 2

@export var move_speed = 1.0

@export var attack_strength = 0.1

@export var attack_cooldown = 1.0

@export var enemy_target:CharacterBody2D

@onready var _health = max_health

var _att_timer = Timer.new()

var _can_attack = true

#sprite should be called - Sprite
#collider should be called - Collider

func _ready():
	#setup for the attack timeframe
	_att_timer.timeout.connect(_attack_timeout)
	_att_timer.autostart = true
	_att_timer.wait_time =  attack_cooldown
	add_child(_att_timer)

func _process(delta: float) -> void:
	#a lerp might be better here. testing will need to be done
	velocity = Vector2()
	#a global request to get local gravity managed in the global settings
	velocity += get_gravity()
	
	#put here as an example
	_move_to_target_by_range(0.1, delta)
	
	#this is important for the sake of framerate synchronization
	velocity = velocity * delta
	
	move_and_slide()
	
func _move_to_target_by_range(range:float, delta:float):
	var difference = get_position() - enemy_target.get_position()
	velocity += sign(difference.x) * move_speed

func _attack_target():
	#a within range check can be done in adition 
	#to make sure the attack is acurate
	if(_can_attack):
		_can_attack = false
		#this is a placeholder no such function exists so far
		enemy_target.deal_damage(attack_strength)

#signals
func _attack_timeout():
	_can_attack = true
