extends Node2D

@onready var enemy = $Beast
@onready var animation_player: AnimationPlayer = $Beast/AnimationPlayer
@onready var skeleton: Skeleton2D = $Beast/SkeletonComponent

@export var horde_controller: GooblinHordeController


var target_list: Array

@export var projectile_spawn_offset = Vector2(0,-140)

@export var bullit_number := 4
var damage_taken = 0
@export var projectile_damage_threshold = 20.0
var bullit = preload("res://Entities/Enemies/Slime/projectile.tscn")

var jump = false
var jump_target
var jump_time
var base_jump_position
var jump_time_passed = 0
var jump_floor



@export var jump_height = 600

func _ready() -> void:
	enemy.reacquire_targets.connect(reacquire_targets)
	reacquire_targets()
	enemy.died.connect(die)

	enemy.took_damage.connect(_spawn_bullits)
	jump_floor = position.y


func _physics_process(delta):
	if jump:
		jump_time_passed += delta
		position.x += delta * (jump_target - base_jump_position) / jump_time
		#print(sin( (PI/2) * jump_time_passed / jump_time))
		position.y = jump_floor - jump_height * sin( (PI/2) * jump_time_passed)


func reacquire_targets():
	target_list = horde_controller.get_basic_gooblins()


func die():
	enemy.state_machine.change_to_state("DeadState")

# Surface level dmg function for the horde to access
func take_damage(dmg):
	enemy.take_damage(dmg)
	
func _spawn_bullits(dmg):
	damage_taken += dmg
	var counter =  0
	if damage_taken >= projectile_damage_threshold:
		damage_taken = 0
		counter =  randi_range(1,bullit_number)
	
	while counter > 0:
		var bul = bullit.instantiate()
		bul.global_position = global_position + projectile_spawn_offset
		get_parent().add_child(bul)
		counter -= 1


# getting deleted asap, debug function
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		enemy.take_damage(1)


func _on_jump_state_jump( new_target , new_jump_time):
	jump = true
	jump_target = new_target
	jump_time = new_jump_time
	base_jump_position = position.x
	jump_time_passed = 0


func _on_jump_state_jump_over():
	jump = false
	print("Stop")
