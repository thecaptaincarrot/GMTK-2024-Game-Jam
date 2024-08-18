extends GenericState

@export var foot_pointer: Node2D
@export var stomper: CollisionShape2D
@export var hitbox: Area2D

@export var damage := 10
@export var non_lethal_damage := 40
@export var peak = 250
@export var x_peak = 70
@export var wind_up_time := 2.0
@export var hold_time := 2.0
@export var stomp_time := 0.5

var intersecting_goobs := []


func enter(_msg):
	stomper.disabled = false
	beast.random_target_timer.stop()
	var prev_foot_pointer_position = foot_pointer.global_position
	
	var tween
	tween = get_tree().create_tween()
	tween.tween_property(foot_pointer, "global_position", prev_foot_pointer_position - Vector2(x_peak, peak), wind_up_time).set_trans(Tween.TRANS_SPRING)
	await tween.finished
	
	tween = get_tree().create_tween()
	tween.tween_property(foot_pointer, "global_position", prev_foot_pointer_position - Vector2(x_peak, peak - 10), hold_time).set_trans(Tween.TRANS_EXPO)
	await tween.finished

	tween = get_tree().create_tween()
	tween.tween_property(foot_pointer, "global_position", prev_foot_pointer_position, stomp_time).set_trans(Tween.TRANS_SPRING)
	await tween.finished
	
	flingerize_gooblins()
	
	state_machine.change_to_state("IdleState")

func flingerize_gooblins():
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
#func handle_input(_event):
	#pass
#
#func update(_delta):
	#pass

func physics_update(_delta):
	intersecting_goobs = hitbox.get_overlapping_bodies()

func exit():
	# once it's done
	stomper.disabled = true
	beast.random_target_timer.start()
