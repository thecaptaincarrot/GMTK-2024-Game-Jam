extends GenericState

@export var head_pointer: Node2D
@export var head_looker: Node2D
@export var hitbox: Area2D
@export var attacker: CollisionShape2D

@export var damage := 30
@export var non_lethal_damage := 30
@export var attack_time := 1.0
@export var attack_height := 20

var intersecting_goobs : Array

func enter(msg):
	attacker.disabled = false
	beast.random_target_timer.stop()
	beast.acquire_targets()
	var prev_position = head_pointer.global_position
	
	var tween
	tween = get_tree().create_tween()
	tween.tween_property(head_pointer, "global_position", Vector2(msg, -attack_height), attack_time).set_trans(Tween.TRANS_ELASTIC)
	await tween.finished
	
	## KILL
	hurt_gooblins()
	
	tween = get_tree().create_tween()
	tween.tween_property(head_pointer, "global_position", prev_position, attack_time/1.5).set_trans(Tween.TRANS_EXPO)
	await tween.finished
	
	state_machine.change_to_state("IdleState")

#func handle_input(_event):
	#pass
#
#func update(_delta):
	#pass
	#if intersecting_goobs:
		#print(intersecting_goobs)

func physics_update(_delta):
	intersecting_goobs = hitbox.get_overlapping_bodies()

func exit():
	# exit clean up
	attacker.disabled = true
	beast.random_target_timer.start()

func hurt_gooblins():
	#print("KILLLLLL")
	var counter = damage
	var fling_counter = non_lethal_damage
	for goob in intersecting_goobs:
		if counter > 0 and goob:
			#print(counter)
			goob.hurt()
			counter -= 1
		if fling_counter > 0 and goob:
			goob.fling()
			fling_counter -= 1
		#if goob.unit_type == Gooblin.GooblinType.SHIELD:
			#if counter > GooblinUpgrades.shield_health * :
				#goob.hurt()
				#counter -= 1
			#else:
				
