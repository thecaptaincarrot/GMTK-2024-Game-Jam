extends GenericState

@export var head_pointer: Node2D
@export var head_looker: Node2D

@export var non_lethal_damage := 5
@export var attack_time := 2.0
@export var attack_height := 20

#almost identical logic with stompstate, refer there for more detailed comments

func enter(msg):
	attacker.disabled = false
	beast.random_target_timer.stop()
	beast.acquire_targets()
	var prev_position = head_pointer.global_position
	
	var tween
	tween = get_tree().create_tween()
	# funky position code, possibly needs looking at, "msg" is the x_target decided on in the IdleState loop
	# i advise turning on the single hidden Sprite2D down in IKTargets to see where the head is trying to go
	tween.tween_property(head_pointer, "global_position", Vector2(msg, attack_height), attack_time).set_trans(Tween.TRANS_ELASTIC)
	await tween.finished
	
	## KILL
	hurt_gooblins()
	
	tween = get_tree().create_tween()
	tween.tween_property(head_pointer, "global_position", prev_position, attack_time/1.5).set_trans(Tween.TRANS_EXPO)
	await tween.finished
	
	state_machine.change_to_state("IdleState")

func physics_update(_delta):
	intersecting_goobs = hitbox.get_overlapping_bodies()

func exit():
	# exit clean up
	attacker.disabled = true
	beast.random_target_timer.start()
