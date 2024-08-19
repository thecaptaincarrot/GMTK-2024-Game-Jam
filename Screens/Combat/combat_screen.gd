extends Node2D

signal ReturnFromCombat


#references
@export var camera : Camera2D

@export var GooblinController : GooblinHordeController

var Enemy : Node2D
var BeastNode : Beast

@export var HealthBar : ProgressBar
@export var CurrentHealthLabel : Label
@export var MaxHealthLabel : Label

@export var DefeatPanel :Panel

#Level Definitions
#Specifics for things like camera bounds, enemy type, other things are stored in an array
#Array indicies correspond to the level being entered.
#I.e. Level 0 will pull all relevant variables from arrays on index 0

#Camera bounds always start at position 0,0 on upper left
const CAMERA_BOUNDS = [ Vector2(2000,1000),
						
						] 

const ENEMY_SCENE = [ preload("res://Entities/Enemies/Dragon/Dragon.tscn"),
					 
					 
					]


const ENEMY_POS = [ Vector2(2000,560)
					
					]





# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func load_level(level_index : int):
	print("Loading")
	camera.limit_right = CAMERA_BOUNDS[level_index].x
	camera.limit_bottom = CAMERA_BOUNDS[level_index].y
	
	camera.position = Vector2(0,camera.limit_bottom)
	
	Enemy = ENEMY_SCENE[level_index].instantiate()
	Enemy.horde_controller = GooblinController
	Enemy.position = ENEMY_POS[level_index]
	add_child(Enemy)
	BeastNode = Enemy.enemy #haha that's a naming oops
	print(BeastNode)
	BeastNode.enemy_hurt.connect(_on_enemy_hurt)
	
	MaxHealthLabel.text = str(BeastNode.max_health)
	CurrentHealthLabel.text = str(BeastNode.max_health)
	
	GooblinController.enemy_node = BeastNode
	#GooblinController.horde_target = BeastNode.get_lunge_point()
	GooblinController.horde_target = $TEST_LUNGE_POINT
	#GooblinController.climb_target = BeastNode.get_climb_target()
	GooblinController.climb_target = $TEST_CLIMB_PATH
	
	HealthBar.show()
	GooblinController.reset()


func _on_enemy_hurt():
	HealthBar.value = BeastNode.health
	CurrentHealthLabel.text = str(BeastNode.health)


func _on_gooblin_horde_controller_gooblin_extinction():
	#calculate gold earned
	var percent_damage_dealt = 1.0 - (BeastNode.health / BeastNode.max_health)
	print
	var gold_earned = round(percent_damage_dealt * BeastNode.get_gold_value())
	print("earned ", gold_earned, " gold")
	GooblinUpgrades.gold += gold_earned
	
	DefeatPanel.update_gold_earned(gold_earned)
	$CanvasLayer/DefeatPanel.show()


func _on_return_button_pressed():
	GooblinController.end_level()
	Enemy.queue_free()
	HealthBar.hide()
	DefeatPanel.hide()
	emit_signal("ReturnFromCombat")
