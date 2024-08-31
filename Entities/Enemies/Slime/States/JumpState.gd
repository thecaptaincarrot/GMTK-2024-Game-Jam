extends GenericState

@export var sprite_radius = 300

@export var animation_player : AnimationPlayer

@export var jump_min = -700
@export var jump_max = 1000

func enter(_msg):
	#Select position on the field to jump to
	var target_position: float = randf_range(jump_min + sprite_radius, jump_max - sprite_radius)
	#var target_position: float = jump_min + sprite_radius
	
	var jump_anim = beast.animation_tree.get_animation("jump_slime")
	var beast_x = jump_anim.find_track(".:position:x", Animation.TYPE_VALUE)
	jump_anim.track_remove_key(beast_x, 1)
	jump_anim.track_insert_key(beast_x, 2.0, target_position)
	
	var undulator_x = jump_anim.find_track("IKTargets/undulator1:position:x", Animation.TYPE_VALUE)
	jump_anim.track_remove_key(undulator_x, 1)
	jump_anim.track_insert_key(undulator_x, 1, beast.position.x - (target_position / 10))
	
	attacker.disabled = false
	#beast.random_target_timer.stop()
	beast.animation_tree["parameters/Jumper/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	await beast.animation_tree.animation_finished
	
	jump_anim.track_remove_key(beast_x, 0)
	jump_anim.track_insert_key(beast_x, 0, target_position)

	#emit_signal("jump",target_position, jump_time)
	#print("Yo1")
	#var new_timer = Timer.new()
	#new_timer.wait_time = jump_time
	#add_child(new_timer)
	#new_timer.start()
	#print(new_timer.time_left)
	#await new_timer.timeout
	#emit_signal("jump_over")
	#shake_off_scalers()
	#hurt_gooblins()
	#flingerize_gooblins()
	
	state_machine.change_to_state("IdleState")


func exit():
	attacker.disabled = true
	#beast.random_target_timer.start()
