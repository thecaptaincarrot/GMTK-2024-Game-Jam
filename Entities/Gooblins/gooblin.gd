extends CharacterBody2D

class_name Gooblin

@export var enemy_target:CharacterBody2D

@export var target_range = 256.0

@export var attack_strength = 0.1

@export var attack_cooldown = 1.0

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
@onready var _sprite = $Sprite
#collider should be called - Collider
@onready var _collider = $Collider


func _ready():
	#setup for the attack timeframe
	_att_timer.timeout.connect(_attack_timeout)
	_att_timer.autostart = true
	_att_timer.wait_time =  attack_cooldown
	add_child(_att_timer)

func _process(delta: float) -> void:
	#a lerp might be better here. testing will need to be done
	velocity = velocity.lerp(Vector2(), dampening)
	#a global request to get local gravity managed in the global settings
	velocity += get_gravity() * delta
	
	#put here as an example
	_move_to_target_range(delta)
	
	if(Input.is_action_just_pressed("ui_accept")):
		fling(Vector2(-600, -800), delta)
	
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

func fling(fling_direction:Vector2, delta:float):
	if(is_on_floor()):
		velocity += fling_direction * 100 * delta

func _move_to_target_range(delta:float):
	if(enemy_target != null):
		if(is_on_floor()):
			var difference = get_position().x - enemy_target.get_position().x
			if(abs(difference) > target_range):
				velocity.x -= sign(difference) * move_speed * delta
				#the 3 used here is just to fuzz the range calculation 
				#and not create an oscillation in the gooblin movement
			elif(abs(difference) + 3 <= target_range):
				velocity.x += sign(difference) * move_speed * delta

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
