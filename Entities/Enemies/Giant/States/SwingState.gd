extends GenericState

@export var arm_target: Node2D

@export var attack_time := 0.4
@export var peak_position := Vector2() # v
@export var attack_position := Vector2() # Going to be a local position

func enter(_msg):
	beast.random_target_timer.stop()
	attacker.disabled = false
	var prev_position = arm_target.position

	var tween
	tween = get_tree().create_tween()
	tween.tween_property(arm_target, "position", peak_position, attack_time *2 ).set_trans(Tween.TRANS_CIRC)
	await tween.finished
	
	## KILL
	hurt_gooblins()
	
	tween = get_tree().create_tween()
	tween.tween_property(arm_target, "position", attack_position, attack_time).set_trans(Tween.TRANS_SPRING)
	await tween.finished

	state_machine.change_to_state("IdleState")

func physics_update(_delta):
	intersecting_goobs = hitbox.get_overlapping_bodies()
	attacker.position = arm_target.position - Vector2(120, 0) # the additional vector is needed to match the sprite

func exit():
	# once it's done
	attacker.disabled = true
	beast.random_target_timer.start()
