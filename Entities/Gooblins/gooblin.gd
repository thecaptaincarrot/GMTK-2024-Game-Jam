extends Area2D

class_name Gooblin

enum GooblinType{
	BASIC,
	SHIELD,
	SCALER,
	CATAPULT
}

signal gooblin_changed

signal died

#Basic vars
@export var unit_type:GooblinType
@export var enemy_node:Node2D
@export var enemy_target:Node2D
@export var path_follower:PathFollow2D

#Set by horde controller
@export var target_range = 256.0
@export var x_home = 0
@export var y_home = 0
@export var attack_radius = 256.0
@export var attack_cooldown = 3.0

#Inherited from upgrades
@export var move_speed = 300.0
@export var shield_health = 0
@export var scaler_climb_speed = 1.0

@export var despawn_timer_time = 2.0

#Vectors
var _upcoming_fling = Vector2()
@export var jump_vector = Vector2(400, 600)
@export var fling_vector = Vector2(-500, -800)
@export var dismount_fling_vector = Vector2(-800, -800)

var velocity = Vector2(0,0)
#used to move the velocity back to zero
#when input is not being sent to movement
#functions off of a vector lerp
@export var dampening = 0.03

var _att_timer = Timer.new()
var _jump_timer = Timer.new()
var _scaler_attack_timer = Timer.new()

#States
var is_flying = false
var _can_attack = true
var _is_dead = false
var celebrating = false
var _is_at_home = false
var _climbing = false
var _climb_started = false
var _scaler_attack_started = false
var _is_being_flung = false


#sprite should be called - Sprite
@onready var _sprite:Sprite2D = $Sprite
#collider should be called - Collider
@onready var _collider:CollisionShape2D = $Collider
@onready var _anim:AnimationPlayer = $AnimationPlayer


func _ready():
	#get stuff from gooblinupgrades
	move_speed = GooblinUpgrades.get_gooblin_speed()
	scaler_climb_speed = GooblinUpgrades.get_scaler_climb_speed()
	#this timer is used to delay a jump
	#and allow for the anticipation animation to play
	_jump_timer.autostart = false
	_jump_timer.set_wait_time(0.3) #Should this be usable?
	_jump_timer.one_shot = true
	_jump_timer.timeout.connect(_jump_trigger)
	add_child(_jump_timer)
	
	_scaler_attack_timer.timeout.connect(_scaler_attack_timeout)
	_scaler_attack_timer.wait_time = 1.0
	_scaler_attack_timer.autostart = false
	_scaler_attack_timer.one_shot = true
	add_child(_scaler_attack_timer) #Do we need a scaler timer if we're not a scaler?
	
	
	var i = randi_range(0, 3) #Should this be more varied?
	if(i == 0):
		y_home = 48
		_sprite.z_index = 3
	elif(i == 1):
		y_home = 32
		_sprite.z_index = 2
	elif(i == 2):
		y_home = 16
		_sprite.z_index = 1
	elif(i == 3):
		y_home = 0
		_sprite.z_index = 0
	
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


func _physics_process(delta: float) -> void:
		#placeholder for speedups
		delta = delta * 1.0
		#gravity, if in the air
		if _is_being_flung:
			if position.y >= y_home:
				position.y = y_home
				_is_being_flung = false
				velocity.y = 0
			else:
				velocity.y += get_gravity() * delta
		else: #I am not being flung, so my y velocity is 0
			velocity.x = _move_to_target_range(delta)
		
		position += velocity * delta
		
		#Flinging:
		if (!_is_dead):
			velocity += _upcoming_fling * delta
		
		_upcoming_fling = Vector2()
		
		

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
	$ScalerTimeout.start()


func celebrate():
	celebrating = true
	
	if _climbing:
		_climbing = false
	
	_anim.play("Victory")


func convert_to_basic_gooblin():
	if(unit_type == GooblinType.SHIELD):
		#spawn a shield entity to bounce around
		var new_shield = load("res://Entities/Gooblins/trash_can.tscn").instantiate()
		new_shield.position = position
		get_parent().call_deferred("add_child",new_shield)
		
		_sprite.texture = load("res://Textures/Entities/GoblinBasic.png")
		_can_attack = true
		unit_type = GooblinType.BASIC
		emit_signal("gooblin_changed", GooblinType.SHIELD, GooblinType.BASIC, self)


func _despawn_timeout():
	queue_free()


func _move_to_target_range(delta:float): #returns the x velocity of the gooblin as it tracks its target
	if celebrating:
		return 0.0

	if(unit_type == Gooblin.GooblinType.SHIELD || unit_type == Gooblin.GooblinType.BASIC):
		if(enemy_target != null):
			var difference = get_position().x - x_home #x_home is ONLY here
			if(abs(difference) > 8.0):
				velocity.x -= sign(difference) * move_speed * delta
				_is_at_home = false
			else:
				_anim.play("Idle")
				_is_at_home = true
	elif(unit_type == Gooblin.GooblinType.SCALER):
		var difference = get_position().x - path_follower.get_global_position().x
		if(abs(difference) > 5):
			velocity.x -= sign(difference) * move_speed * delta
		elif(abs(difference) <= 5 && !_climbing && $ScalerTimeout.is_stopped()):
			print("climbing",$ScalerTimeout.is_stopped())
			_climbing = true
		elif(_climbing and !_scaler_attack_started):
			_anim.play("Climb")
			set_position(path_follower.get_global_position())
			if(path_follower.progress_ratio < 1.0):
				path_follower.progress += scaler_climb_speed * delta
		else:
			pass


func _attack_target():
	if(unit_type == GooblinType.BASIC):
		#a within range check can be done in adition 
		#to make sure the attack is acurate
		if(_is_at_home && _can_attack):
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
