extends GenericState

@export var head_pointer: Node2D
@export var head_looker: Node2D
@export var hitbox: Area2D
@export var attacker: CollisionShape2D

@export var damage := 10
@export var attack_time := 2.0
@export var attack_height := 80

var intersecting_goobs : Array

#func _ready():
	#hitbox.body_entered.connect(_add_to_goob_list)
	#pass
#
#func _add_to_goob_list(goob):
	#if goob not in intersecting_goobs and goob in beast.targets:
		#intersecting_goobs.append(goob)
	#print("intersect")
	#print(intersecting_goobs.size())
var final_targets: Array

func enter(msg):
	beast.acquire_targets()
	var prev_position = head_pointer.global_position
	
	var tween
	tween = get_tree().create_tween()
	tween.tween_property(head_pointer, "global_position", msg.global_position - Vector2(0, attack_height), attack_time).set_trans(Tween.TRANS_ELASTIC)
	await tween.finished
	
	## KILL
	#attacker.disabled = false
	
	var timer = get_tree().create_timer(0.2)
	
	hurt_gooblins()
	
	await timer.timeout	
	#attacker.disabled = true
	final_targets.clear()
	

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
	for i in intersecting_goobs:
		if i not in final_targets:
			final_targets.append(i)
	#print(intersecting_goobs.size())
	#print(final_targets.size())
	#if intersecting_goobs:
		#print(intersecting_goobs)
	#intersecting_goobs.clear()

func exit():
	# once it's done
	beast.random_target_timer.start()

func hurt_gooblins():
	#print("KILLLLLL")
	var counter = damage
	for goob in intersecting_goobs:
		if goob.unit_type = Gooblin.GooblinType.SHIELD:
			if dmg > shield
		#print("KILL")
		if counter > 0: #and hitbox.overlaps_body(goob): #and randi_range(0,1) == 0:
			print(counter)
			#if not goob.is_dead():
			goob.hurt(2)
			counter -= 1
