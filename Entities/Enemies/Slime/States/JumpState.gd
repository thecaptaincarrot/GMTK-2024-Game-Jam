extends GenericState


@export var return_hint: Node2D # the ground

@export var jump_peak := -300 #global

@export var sprite_radius = 300
@export var jump_height = 600
@export var jump_time = 2.0

@export var animation_player : AnimationPlayer
@export var slime_node : Node2D

@export var jump_range = 2000

var home : Vector2

signal jump
signal jump_over

func _ready():
	home = return_hint.global_position


func enter(x_target):
	#Select position on the field to jump to
	var target_position = randf_range(0 + sprite_radius, jump_range - sprite_radius)
	attacker.disabled = false
	
	emit_signal("jump",target_position, jump_time)
	print("Yo1")
	var new_timer = Timer.new()
	new_timer.wait_time = jump_time
	add_child(new_timer)
	new_timer.start()
	print(new_timer.time_left)
	await new_timer.timeout
	print("Yo")
	emit_signal("jump_over")
	
	hurt_gooblins()
	flingerize_gooblins()
	
	state_machine.change_to_state("IdleState")


func exit():
	attacker.disabled = true
