extends CharacterBody2D

class_name Gooblin

enum GooblinType{
	BASIC,
	SHIELD,
	ASSASSIN,
	CATAPULT
}

@export var unit_type:GooblinType

@export var enemy_target:Node2D

@export var target_range = 256.0

@export var x_home = 0

@export var attack_strength = 0.1

@export var attack_cooldown = 3.0

@export var attack_radius = 256.0

@export var max_health = 2

@export var move_speed = 300.0

#used to move the velocity back to zero
#when input is not being sent to movement
#functions off of a vector lerp
@export var dampening = 0.03

@onready var _health = max_health

var _att_timer = Timer.new()

var _can_attack = true

#sprite should be called - Sprite
@onready var _sprite:Sprite2D = $Sprite
#collider should be called - Collider
@onready var _collider = $Collider

var _upcoming_fling = Vector2()

var _is_at_home = false

func _ready():
	#setup for the attack timeframe
	if(unit_type == GooblinType.BASIC):
		_can_attack = true
	elif(unit_type == GooblinType.SHIELD):
		_sprite.set_self_modulate(Color(1, 0, 1))
		_can_attack = false

	else:
		pass
	

func _process(delta: float) -> void:
	#a lerp might be better here. testing will need to be done
	velocity = velocity.lerp(Vector2(), dampening)
	#a global request to get local gravity managed in the global settings
	velocity += get_gravity() * delta
	
	#put here as an example
	_move_to_target_range(delta)
	
	velocity += _upcoming_fling * delta
	_upcoming_fling = Vector2()
	
	_attack_target()
	
	move_and_slide()

func hurt(amount:int):
	_health -= amount
	if(_health <= 0):
		_health = 0
		die()

func heal(amount:int):
	_health += amount
	if(_health > max_health):
		_health = max_health

func die():
	pass

func _move_to_target_range(delta:float):
	if(enemy_target != null):
		if(is_on_floor()):
			var difference = get_position().x - x_home
			if(abs(difference) > 8.0):
				velocity.x -= sign(difference) * move_speed * delta
				_is_at_home = false
			else:
				_is_at_home = true

func _attack_target():
	#a within range check can be done in adition 
	#to make sure the attack is acurate
	if(_is_at_home && is_on_floor() && _can_attack):
		if(abs(get_position().x - enemy_target.get_position().x) <= attack_radius):
			var diff = (get_position() - enemy_target.get_position()).normalized()
			_upcoming_fling = -diff * Vector2(300, 400) * 100
