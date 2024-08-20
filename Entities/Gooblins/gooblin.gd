extends CharacterBody2D

class_name Gooblin

enum GooblinType{
	BASIC,
	SHIELD,
	SCALER,
	CATAPULT
}

@export var unit_type:GooblinType

@export var enemy_node:Node2D

@export var enemy_target:Node2D

@export var target_range = 256.0

@export var x_home = 0

@export var attack_cooldown = 3.0

@export var attack_radius = 256.0

@export var move_speed = 300.0

@export var shield_health = 0

@export var despawn_timer_time = 2.0

@export var jump_vector = Vector2(400, 600)

@export var fling_vector = Vector2(-500, -800)

@export var dismount_fling_vector = Vector2(-800, -800)

@export var scaler_climb_speed = 1.0


@export var path_follower:PathFollow2D

#used to move the velocity back to zero
#when input is not being sent to movement
#functions off of a vector lerp
@export var dampening = 0.03

var _att_timer = Timer.new()

var _jump_timer = Timer.new()

var _scaler_attack_timer = Timer.new()

var _can_attack = true

var _is_dead = false

#sprite should be called - Sprite
@onready var _sprite:Sprite2D = $Sprite
#collider should be called - Collider
@onready var _collider:CollisionShape2D = $Collider

@onready var _anim:AnimationPlayer = $AnimationPlayer

var _upcoming_fling = Vector2()

var _is_at_home = false

var _climbing = false

var _climb_started = false

var _scaler_attack_started = false

var _is_being_flung = false

signal gooblin_changed

signal died

func _ready():
	#this timer is used to delay a jump
	#and allow for the anticipation animation to play
	_jump_timer.autostart = false
	_jump_timer.set_wait_time(0.3)
	_jump_timer.one_shot = true
	_jump_timer.timeout.connect(_jump_trigger)
	add_child(_jump_timer)
	
	
	_scaler_attack_timer.timeout.connect(_scaler_attack_timeout)
	_scaler_attack_timer.wait_time = 1.0
	_scaler_attack_timer.autostart = false
	_scaler_attack_timer.one_shot = true
	
	
	
	add_child(_scaler_attack_timer)
	#
	randomize()
	var i = randi_range(0, 3)
	if(i == 0):
		_sprite.position = Vector2(0, 64)
		_sprite.z_index = -30
	elif(i == 1):
		_sprite.position = Vector2(0, 32)
		_sprite.z_index = -40
	elif(i == 2):
		_sprite.position = Vector2(0, 16)
		_sprite.z_index = -50
	elif(i == 3):
		_sprite.position = Vector2(0, 0)
		_sprite.z_index = -60
	
	#setup for the attack timeframe
	if(unit_type == GooblinType.BASIC):
		_can_attack = true
	elif(unit_type == GooblinType.SHIELD):
		_sprite.texture = load("res://Textures/Entities/GoblinShield.png")
		shield_health = GooblinUpgrades.shield_health
		_can_attack = false
	elif(unit_type == GooblinType.SCALER):
		_sprite.texture = load("res://Textures/Entities/GoblinScaler.png")
		_can_attack = true
		pass

func _process(delta: float) -> void:
		#a lerp might be better here. testing will need to be done
		velocity = velocity.lerp(Vector2(), dampening)
		
		if(!_climbing):
			#a global request to get local gravity managed in the global settings
			velocity += get_gravity() * delta
		
		if (!_is_dead):
			velocity += _upcoming_fling * delta
		
		_upcoming_fling = Vector2()
		
		if(!_is_dead):
			#put here as an example
			_move_to_target_range(delta)
			_attack_target()
		
		move_and_slide()

func hurt():
	if(unit_type == GooblinType.SHIELD):
		shield_health -= 1
		if shield_health <= 0:
			convert_to_basic_gooblin()
	elif(unit_type == GooblinType.BASIC):
		die()
	elif(unit_type == GooblinType.SCALER):
		die()

func die():
	_is_dead = true
	emit_signal("died", self)
	var despawn_timer = Timer.new()
	despawn_timer.autostart = true
	despawn_timer.set_wait_time(despawn_timer_time)
	despawn_timer.timeout.connect(_despawn_timeout)
	add_child(despawn_timer)
	_anim.play("Dead")
	$Splat.amount = randi_range(10,40)
	$Splat.emitting = true

func fling():
	_is_being_flung = true
	_upcoming_fling = fling_vector * 100
	

func convert_to_basic_gooblin():
	if(unit_type == GooblinType.SHIELD):
		#spawn a shield entity to bounce around
		_sprite.texture = load("res://Textures/Entities/GoblinBasic.png")
		_can_attack = true
		unit_type = GooblinType.BASIC
		emit_signal("gooblin_changed", GooblinType.SHIELD, GooblinType.BASIC, self)


func _despawn_timeout():
	queue_free()


func _move_to_target_range(delta:float):
	if(unit_type == Gooblin.GooblinType.SHIELD || unit_type == Gooblin.GooblinType.BASIC):
		if(enemy_target != null):
			if(is_on_floor()):
				if _is_being_flung: _is_being_flung = false
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
			else:
				if _is_being_flung:
					_anim.play("Fling")
	elif(unit_type == Gooblin.GooblinType.SCALER):
		var difference = get_position().x - path_follower.get_global_position().x
		if(abs(difference) > 5 && is_on_floor()):
			_anim.play("Walk")
			velocity.x -= sign(difference) * move_speed * delta
		elif(abs(difference) <= 5 && !_climbing):
			_climbing = true
		elif(_climbing and !_scaler_attack_started):
			_anim.play("Climb")
			set_position(path_follower.get_global_position())
			if(path_follower.progress_ratio < 1.0):
				path_follower.progress += scaler_climb_speed * 50 * delta
		else:
			pass


func _attack_target():
	if(unit_type == GooblinType.BASIC):
		#a within range check can be done in adition 
		#to make sure the attack is acurate
		if(_is_at_home && is_on_floor() && _can_attack):
			if(abs(get_position().x - enemy_target.get_global_position().x) <= attack_radius):
				_anim.play("Jump")
				_jump_timer.start()
	
	if(unit_type == GooblinType.SCALER && path_follower.progress_ratio == 1 && _climbing == true && !_scaler_attack_started):
		_scaler_attack_timer.start()
		_anim.play("ScalerAttack")
		_scaler_attack_started = true
		$ScalerDamage.color = enemy_node.blood_color


func _jump_trigger():
	var diff = (get_position() - enemy_target.get_global_position()).normalized()
	if(_upcoming_fling == Vector2()):
		_upcoming_fling = -diff * jump_vector * 100
		#add damange multiplyers in here when it comes up
		enemy_node.take_damage(GooblinUpgrades.gooblin_attack)


func _scaler_attack_timeout():
	enemy_node.take_damage(GooblinUpgrades.gooblin_attack * GooblinUpgrades.get_scaler_multipler())
	fling()
	_anim.play("Fling")
	_climbing = false
	path_follower.progress_ratio = 0
	_scaler_attack_started = false


func is_dead():
	return _is_dead
