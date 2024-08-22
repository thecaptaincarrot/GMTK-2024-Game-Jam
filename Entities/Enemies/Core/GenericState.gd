class_name GenericState extends Node

## This state acts as reference to set up the state you're working on
# Add states as children to the StateMachine node

# Reference to FSM added so you can swap between states from inside the state
@onready var state_machine = $".."

# Reference to the health etc of the enemy in question
@onready var beast: Beast = state_machine.get_parent()

# The animation is an export variable !!!
@export var animation: String = "universal_idle"

signal screen_shake #for really cool attacks
signal shake_off

#For Attacks
@export var hitbox: Area2D
@export var attacker: CollisionShape2D
@export var damage = 10
@export var scaler_shakeoff_chance = 0.5
@export var hit_sound_player : AudioStreamPlayer

#for Kicks
@export var stomper: CollisionShape2D
@export var fling_damage = 10

func enter(_msg):
	pass

func handle_input(_event):
	pass

func update(_delta):
	pass

var intersecting_goobs := []
func physics_update(_delta):
	if hitbox:
		intersecting_goobs = hitbox.get_overlapping_bodies()

func exit():
	pass


func shake_off_scalers():
	shake_off.emit(scaler_shakeoff_chance)


func flingerize_gooblins():
	if len(intersecting_goobs) == 0:
		return
	var to_fling = fling_damage
	for goob in intersecting_goobs:
		goob.fling()
		to_fling -= 1
		if to_fling <=0:
			break


func hurt_gooblins():
	#if hit_sound_player:
		#hit_sound_player.play()
	
	if len(intersecting_goobs) == 0:
		return
	
	var to_hurt = damage
	
	var num_shields = 0
	var shield_goobs = []
	for goob in intersecting_goobs:
		if goob.unit_type == goob.GooblinType.SHIELD:
			shield_goobs.append(goob)
			num_shields += goob.shield_health
	
	#assign to shields first
	if num_shields > 0:
		for i in range(0,damage):
			var unlucky_goob = shield_goobs.pick_random()
			unlucky_goob.hurt()
			if unlucky_goob.shield_health <= 0:
				shield_goobs.erase(unlucky_goob)
			to_hurt -= 1
			num_shields -= 1
			if num_shields <= 0:
				break

	for i in range(0,to_hurt):
		var unlucky_goob = intersecting_goobs.pick_random()
		intersecting_goobs.erase(unlucky_goob)
		unlucky_goob.hurt()
		if len(intersecting_goobs) == 0:
			return
