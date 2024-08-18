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

@export var despawn_timer = 5.0

#used to move the velocity back to zero
#when input is not being sent to movement
#functions off of a vector lerp
@export var dampening = 0.03

@onready var _health = max_health

var _att_timer = Timer.new()

var _jump_timer = Timer.new()

var _can_attack = true

var _is_dead = false

#sprite should be called - Sprite
@onready var _sprite:Sprite2D = $Sprite
#collider should be called - Collider
@onready var _collider:CollisionShape2D = $Collider

@onready var _anim:AnimationPlayer = $AnimationPlayer

var _upcoming_fling = Vector2()

var _is_at_home = false

signal gooblin_changed
signal died

func _ready():
	#this timer is used to delay a jump
	#and allow for the anticipation animation to play
	_jump_timer.autostart = false
	_jump_timer.set_wait_time(0.6)
	_jump_timer.one_shot = true
	_jump_timer.timeout.connect(_jump_trigger)
	add_child(_jump_timer)
	#
	randomize()
	var i = randi_range(0, 3)
	if(i == 0):
		_sprite.position = Vector2(0, 64)
		_sprite.z_index = 3
	elif(i == 1):
		_sprite.position = Vector2(0, 32)
		_sprite.z_index = 2
	elif(i == 2):
		_sprite.position = Vector2(0, 16)
		_sprite.z_index = 1
	elif(i == 3):
		_sprite.position = Vector2(0, 0)
		_sprite.z_index = 0
	
	#setup for the attack timeframe
	if(unit_type == GooblinType.BASIC):
		_can_attack = true
	elif(unit_type == GooblinType.SHIELD):
		_sprite.texture = load("res://Textures/Entities/GoblinShield.png")
		_can_attack = false

	else:
		pass
	

func _process(delta: float) -> void:
	if(!_is_dead):
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
	_is_dead = true
	emit_signal("Dead", self)
	var despawn_timer = Timer.new()
	despawn_timer.auto_start = true
	despawn_timer.set_wait_time(despawn_timer)
	despawn_timer.timeout.connect(_despawn_timeout)
	add_child(despawn_timer)
	_anim.play("Dead")

func convert_to_basic_gooblin():
	if(unit_type == GooblinType.SHIELD):
		#spawn a shield entity to bounce around
		_sprite.texture = load("res://Textures/Entities/GoblinBasic.png")
		_can_attack = true
		emit_signal("gooblin_changed", GooblinType.SHIELD, GooblinType.BASIC, self)

func _despawn_timeout():
	queue_free()

func _move_to_target_range(delta:float):
	if(enemy_target != null):
		if(is_on_floor()):
			var difference = get_position().x - x_home
			if(abs(difference) > 8.0):
				velocity.x -= sign(difference) * move_speed * delta
				_is_at_home = false
				if(_anim.current_animation != "Walk" && is_on_floor()):
					if(_anim.current_animation != "Jump" || !_anim.is_playing()):
						_anim.play("Walk")
			else:
				_anim.play("Idle")
				_is_at_home = true

func _attack_target():
	#a within range check can be done in adition 
	#to make sure the attack is acurate
	if(_is_at_home && is_on_floor() && _can_attack):
		if(abs(get_position().x - enemy_target.get_global_position().x) <= attack_radius):
			_anim.play("Jump")
			_jump_timer.start()

func _jump_trigger():
	var diff = (get_position() - enemy_target.get_global_position()).normalized()
	_upcoming_fling = -diff * Vector2(400, 600) * 100

func is_dead():
	return _is_dead
