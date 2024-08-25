extends GenericState

func enter(msg):
	var slam_anim = beast.animation_tree.get_animation("slam")
	var slam_track = slam_anim.find_track("IKTargets/headTarget:position:x", Animation.TYPE_VALUE)
	slam_anim.track_remove_key(slam_track, 1)
	slam_anim.track_insert_key(slam_track, 0.3, msg)
	#printt("track:", beast.animation_tree.get_animation("slam").track_get_path(slam_track))

	attacker.disabled = false
	beast.random_target_timer.stop()
	beast.animation_tree["parameters/Slammer/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	await beast.animation_tree.animation_finished
	#
	### KILL
	#hurt_gooblins()
	#flingerize_gooblins()
	#shake_off_scalers()
	#emit_signal("screen_shake")
	
	# pass both the position to the stagger state so it can get up properly
	state_machine.change_to_state("StaggerState", msg)

func exit():
	# exit clean up
	attacker.disabled = true
	#beast.animation_tree["parameters/SlamMachine/conditions/slamming"] = false
