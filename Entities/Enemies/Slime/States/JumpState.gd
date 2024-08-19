extends GenericState

@export var attacker: Node2D

@export var return_hint: Node2D # the ground

@export var damage := 10
@export var non_lethal_damage := 10
@export var jump_peak := -300 #global
@export var jump_time := 3.0 

func enter(x_target):
	# genuinely horrible jump code but it works
	var return_pos = return_hint.global_position.y
	attacker.disabled = false
	var tween
	tween = get_tree().create_tween()
	tween.tween_property(beast.get_parent(), "global_position", Vector2((beast.global_position.x + x_target)/2, jump_peak), jump_time*4/5).set_trans(Tween.EASE_OUT_IN)
	await tween.finished

	tween = get_tree().create_tween()
	tween.tween_property(beast.get_parent(), "global_position", Vector2(x_target, return_pos), jump_time/5).set_trans(Tween.EASE_OUT_IN)
	await tween.finished

	hurt_gooblins()
	
	state_machine.change_to_state("IdleState")

func exit():
	attacker.disabled = true

func hurt_gooblins():
	# i cant copy&paste again i cant
	pass
