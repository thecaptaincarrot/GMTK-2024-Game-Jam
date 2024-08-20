extends GenericState

@export var leg_target: Node2D
@export var pull_back_time := 1.0
@export var kick_time := 0.5
@export var pull_back: Vector2
@export var kick_goal: Vector2


func enter(_msg):
	beast.random_target_timer.stop()
	attacker.disabled = false
	var prev_position = leg_target.position
	
	var tween
	tween = get_tree().create_tween()
	tween.tween_property(leg_target, "position", pull_back, pull_back_time).set_trans(Tween.TRANS_BOUNCE)
	await tween.finished
	
	tween = get_tree().create_tween()
	tween.tween_property(leg_target, "position", kick_goal, kick_time).set_trans(Tween.TRANS_QUINT)
	await tween.finished
	
	flingerize_gooblins()
	
	state_machine.change_to_state("IdleState")

func exit():
	# once it's done
	attacker.disabled = true
	beast.random_target_timer.start()


func physics_update(_delta):
	intersecting_goobs = hitbox.get_overlapping_bodies()
