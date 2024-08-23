extends GenericState

@export var head_pointer: Node2D
@export var head_looker: Node2D

@export var non_lethal_damage := 30
@export var attack_time := 1.0
@export var attack_height := 10

func enter(msg):
	var slam_anim = beast.animation_tree.get_animation("slam")
	slam_anim.track_remove_key(0, 0)
	slam_anim.bezier_track_insert_key(0, 0.3, msg)
	printt("track:", beast.animation_tree.get_animation("slam").track_get_path(0))

	attacker.disabled = false
	beast.random_target_timer.stop()
	beast.animation_tree["parameters/SlamMachine/conditions/slamming"] = true
	beast.animation_tree["parameters/Slammer/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	await beast.animation_tree.animation_finished
	
	## KILL
	hurt_gooblins()
	flingerize_gooblins()
	shake_off_scalers()
	emit_signal("screen_shake")
	
	# pass both the position and attack time to the stagger state so it can get up properly
	state_machine.change_to_state("StaggerState", msg)

func exit():
	# exit clean up
	attacker.disabled = true
	beast.animation_tree["parameters/SlamMachine/conditions/slamming"] = false
