extends Area2D

class_name Gooblin

enum GooblinType{
	BASIC,
	SHIELD,
	SCALER,
	CATAPULT
}


enum GooblinStates{
	IDLE,
	MOVING,
	JUMPATTACK,
	CLIMBING,
	FLYING,
	DEAD,
	CELEBRATING
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
@export var jump_power = 600.0
@export var fling_vector = Vector2(-400, -800)
@export var dismount_fling_vector = Vector2(-80, -80)

var velocity = Vector2(0,0)
#used to move the velocity back to zero
#when input is not being sent to movement
#functions off of a vector lerp
@export var dampening = 0.2

var _att_timer = Timer.new()
var _jump_timer = Timer.new()
var _scaler_attack_timer = Timer.new()

#States
@export var state = GooblinStates.IDLE
var prev_state = GooblinStates.IDLE

var _can_attack = true
var _is_at_home = false
var _jump_started = false
var _scaler_attack_started = false


#sprite should be called - Sprite
@onready var _sprite:Sprite2D = $Sprite
#collider should be called - Collider
@onready var _collider:CollisionShape2D = $Collider
@onready var _anim:AnimationPlayer = $AnimationPlayer

#this was moved up here to shift the "lag" to the start of the game
#and not the first time this scene get's spawned
@onready var trash_can_scene = preload("res://Entities/Gooblins/trash_can.tscn")

func _ready():
	#get stuff from gooblinupgrades
	move_speed = GooblinUpgrades.get_gooblin_speed()
	scaler_climb_speed = GooblinUpgrades.get_scaler_climb_speed()

	_scaler_attack_timer.timeout.connect(_scaler_attack_timeout)
	_scaler_attack_timer.wait_time = 1.0
	_scaler_attack_timer.autostart = false
	_scaler_attack_timer.one_shot = true
	add_child(_scaler_attack_timer) #Do we need a scaler timer if we're not a scaler?
	
	#The y offset also defines the layer the gooblin will render on
	y_home = position.y
	_sprite.z_index = y_home
	
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
		move_speed = GooblinUpgrades.gooblin_base_move_speed - 15.0
		$Splat.color = Color.MEDIUM_PURPLE
		$ScalerDamage.color = enemy_node.blood_color


func _process(delta):
	pass


func _physics_process(delta: float) -> void:
		#placeholder for speedups
	delta = delta * 1.0
		#state machine
	
	match state:
		GooblinStates.IDLE:
			velocity.x = lerp(velocity.x,_move_to_target_range(),dampening)
			_attack_target()
		GooblinStates.MOVING:
			velocity.x = lerp(velocity.x,_move_to_target_range(),dampening)
			_attack_target()
		GooblinStates.JUMPATTACK:
			#I wish _jump_started wasn't needed. Please find a way to get rid of it.
			if _jump_started:
				if position.y > y_home:
					position.y = y_home
					_state_changed(GooblinStates.IDLE)
					velocity.y = 0
				else:
					velocity.y += get_gravity() * delta
		GooblinStates.CLIMBING:
			velocity = Vector2(0,0)
			position = path_follower.global_position
			if !_scaler_attack_started:
				path_follower.progress += scaler_climb_speed * delta
				if path_follower.progress_ratio == 1.0: #completed my climb
					_scaler_attack_started = true
					_scaler_attack_timer.start()
					$ScalerDamage.show()
					_anim.play("ScalerAttack")
			else:
				path_follower.progress_ratio = 1.0
		GooblinStates.FLYING:
			if position.y > y_home:
				position.y = y_home
				_state_changed(GooblinStates.IDLE)
				velocity.y = 0
			else:
				velocity.y += get_gravity() * delta
		GooblinStates.DEAD:
			if position.y >= y_home:
				position.y = y_home
				velocity.y = 0
				velocity.x = lerp(velocity.x,0.0,dampening)
			else:
				velocity.y += get_gravity() * delta
		GooblinStates.CELEBRATING:
			if position.y >= y_home:
				position.y = y_home
				velocity.y = 0
				velocity.x = lerp(velocity.x,0.0,dampening)
			else:
				velocity.y += get_gravity() * delta
		
	position += velocity * delta


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
	_state_changed(GooblinStates.DEAD)
	emit_signal("died", self)
	var despawn_timer = Timer.new()
	despawn_timer.autostart = true
	despawn_timer.set_wait_time(despawn_timer_time)
	despawn_timer.timeout.connect(_despawn_timeout)
	add_child(despawn_timer)
	$Splat.amount = randi_range(10,40)
	$Splat.emitting = true


func fling():
	if not is_dead():
		_scaler_attack_started = false
		if path_follower:
			path_follower.progress_ratio = 0
		_state_changed(GooblinStates.FLYING)
		velocity = fling_vector
		$ScalerDamage.emitting = false
		$ScalerDamage.hide()
		$ScalerTimeout.start()


func celebrate():
	_state_changed(GooblinStates.CELEBRATING)


func convert_to_basic_gooblin():
	if(unit_type == GooblinType.SHIELD):
		#spawn a shield entity to bounce around
		var new_shield = trash_can_scene.instantiate()
		new_shield.position = position - Vector2(0, _sprite.get_rect().size.y)
		get_parent().call_deferred("add_child",new_shield)
		
		_sprite.texture = load("res://Textures/Entities/GoblinBasic.png")
		_can_attack = true
		unit_type = GooblinType.BASIC
		emit_signal("gooblin_changed", GooblinType.SHIELD, GooblinType.BASIC, self)


func _despawn_timeout():
	queue_free()


func _move_to_target_range(): #returns the x velocity of the gooblin as it tracks its target
	#I want to remove all animations from this
	var x_velocity = 0.0
	
	if(unit_type == Gooblin.GooblinType.SHIELD || unit_type == Gooblin.GooblinType.BASIC):
		if(enemy_target != null):
			var difference = get_position().x - x_home #x_home is where the gooblin wants to go
			if(abs(difference) > 8.0):
				x_velocity -= sign(difference) * move_speed
				if state != GooblinStates.MOVING:
					_state_changed(GooblinStates.MOVING)
				_is_at_home = false
			else:
				_state_changed(GooblinStates.IDLE)
				_is_at_home = true
	elif(unit_type == Gooblin.GooblinType.SCALER):
		if enemy_node :
			var difference = get_position().x - path_follower.get_global_position().x
			if(abs(difference) > 5):
				x_velocity -= sign(difference)  * move_speed
				if state != GooblinStates.MOVING:
					_state_changed(GooblinStates.MOVING)
			elif(abs(difference) <= 5 && state != GooblinStates.CLIMBING && $ScalerTimeout.is_stopped()):
				_state_changed(GooblinStates.CLIMBING)
	else:
		pass
	return x_velocity


func _attack_target():
	if(unit_type == GooblinType.BASIC):
		#a within range check can be done in adition 
		#to make sure the attack is acurate
		if(_is_at_home && _can_attack):
			if(abs(get_position().x - enemy_target.get_global_position().x) <= attack_radius):
				_state_changed(GooblinStates.JUMPATTACK)


func _jump_trigger():
	#var diff = (get_position() - enemy_target.get_global_position()).normalized()
	#TODO:REFERENCE THE TARGET POSITION, NOT JUST A BOGUS VECTOR
	var dif = Vector2(0.4,-0.6)
	velocity = dif * jump_power
	_jump_started = true


func damage_target():
	enemy_node.take_damage(GooblinUpgrades.gooblin_attack)


func _scaler_attack_timeout():
	#printt("Damaging for",GooblinUpgrades.gooblin_attack * GooblinUpgrades.get_scaler_multipler())
	enemy_node.take_damage(GooblinUpgrades.gooblin_attack * GooblinUpgrades.get_scaler_multipler())
	fling()
	_state_changed(GooblinStates.FLYING)
	path_follower.progress_ratio = 0
	_scaler_attack_started = false


func _state_changed(new_state):
	#This only handles animation changes, or other things that change when an animation changes
	#it does NOT handle what causes a state to change
	
	prev_state = state
	state = new_state
	#If you can find a way to get rid of this reset, please do so.
	_jump_started = false
	#Back to your regularly scheduled function
	match state:
		GooblinStates.IDLE:
			_anim.play("Idle")
		GooblinStates.MOVING:
			_anim.play("Walk")
		GooblinStates.JUMPATTACK:
			_anim.play("Jump")
		GooblinStates.CLIMBING:
			path_follower.progress_ratio = 0.0
			_anim.play("Climb")
		GooblinStates.FLYING:
			_anim.play("Fling")
		GooblinStates.DEAD:
			_anim.play("Dead")
		GooblinStates.CELEBRATING:
			_anim.play("Victory")


func is_dead():
	if state == GooblinStates.DEAD:
		return true
	else:
		return false
