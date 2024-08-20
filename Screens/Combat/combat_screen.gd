extends Node2D

signal ReturnFromCombat


#references
@export var music_player : AudioStreamPlayer
@export var click_player : AudioStreamPlayer
@export var victory_player : AudioStreamPlayer
@export var defeat_player : AudioStreamPlayer

@export var camera : Camera2D

@export var GooblinController : GooblinHordeController

var Enemy : Node2D
var BeastNode : Beast

@export var HealthBar : ProgressBar
@export var CurrentHealthLabel : Label
@export var MaxHealthLabel : Label
@export var Canvas_Layer : CanvasLayer

@export var DefeatPanel :Panel
@export var VictoryPanel:Panel

@export var FieldFloor : StaticBody2D
@export var CaveFloor : StaticBody2D

const FIELD_BG = 0
const CAVE_BG = 1
const DRY_BG = 2
const LAKE_BG = 3

#Level Definitions
#Specifics for things like camera bounds, enemy type, other things are stored in an array
#Array indicies correspond to the level being entered.
#I.e. Level 0 will pull all relevant variables from arrays on index 0

#Camera bounds always start at position 0,0 on upper left
const CAMERA_BOUNDS = [ Vector2(1400,900),
						Vector2(1400,900),
						Vector2(1600,900),
						Vector2(1600,900),
						Vector2(2000,1100),
						] 

const ENEMY_SCENE = [ preload("res://Entities/Enemies/Knight/Knight.tscn"), 
					  preload("res://Entities/Enemies/Giant/Giant.tscn"), 
					  preload("res://Entities/Enemies/Slime/Slime.tscn"), 
					  preload("res://Entities/Enemies/Wyrm/wyrm.tscn"), 
					  preload("res://Entities/Enemies/Dragon/Dragon.tscn"),
					]


const ENEMY_POS = [ Vector2(1100, 640),
					Vector2(1100,680),
					Vector2(1400,720),
					Vector2(1500,800),
					Vector2(1800,540),
					]

const GOOBLIN_RANGE = [100,
					   100,
					   100,
					   100,
					   128,
					]

const ENEMY_HEALTH = [200,
					  1000,
					  1000,
					  1000,
					  1000,
]

const ENEMY_REWARD = [100,
					  1000,
					  1000,
					  1000,
					  1000,
					]

const BACKGROUND = [ FIELD_BG,
					 FIELD_BG,
					 FIELD_BG,
					 DRY_BG,
					 CAVE_BG
	
]


const FLOOR = [0,
				0,
				0,
				0,
				1
				]

var active_loaded_level = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func load_level(level_index : int):
	print("Loading")
	active_loaded_level = level_index
	camera.limit_right = CAMERA_BOUNDS[level_index].x
	camera.limit_bottom = CAMERA_BOUNDS[level_index].y
	
	_hide_all_backgrounds()
	if(BACKGROUND[level_index] == CAVE_BG):
		$Background/BackgroundParallax/CaveBackground.visible = true
		$"Background/CeilingParallax/CaveCeiling".visible = true
		$Background/FloorParallax/CaveFloor.visible = true
	elif(BACKGROUND[level_index] == FIELD_BG):
		$Background/FloorParallax/FieldFloor.visible = true
		$Background/BackgroundParallax/FieldBackground.visible = true
	elif(BACKGROUND[level_index] == DRY_BG):
		$Background/BackgroundParallax/FieldBackground.visible = true
		$Background/FloorParallax/DryFloor.visible = true
		$Background/FloorParallax.repeat_size.x = 2036
	
	if FLOOR[level_index] == 0:
		FieldFloor.collision_layer = 1
		FieldFloor.collision_mask = 1
	else:
		FieldFloor.collision_layer = 0
		FieldFloor.collision_mask = 0
	
	GooblinController.horde_range = GOOBLIN_RANGE[level_index]
	
	camera.position = Vector2(0,camera.limit_bottom)
	
	Enemy = ENEMY_SCENE[level_index].instantiate()
	Enemy.horde_controller = GooblinController
	print(GooblinController)
	Enemy.position = ENEMY_POS[level_index]
	Enemy.get_node("Beast").max_health = ENEMY_HEALTH[level_index]
	Enemy.get_node("Beast").gold_value = ENEMY_HEALTH[level_index]
	add_child(Enemy)
	BeastNode = Enemy.enemy #haha that's a naming oops
	BeastNode.shake_screen.connect(camera.shake_screen)
	print(BeastNode)
	BeastNode.enemy_hurt.connect(_on_enemy_hurt)
	BeastNode.died.connect(_on_beast_died)
	
	MaxHealthLabel.text = str(BeastNode.max_health)
	CurrentHealthLabel.text = str(BeastNode.max_health)
	HealthBar.max_value = BeastNode.max_health
	
	GooblinController.enemy_node = BeastNode
	GooblinController.horde_target = BeastNode.get_lunge_point()
	GooblinController.climb_target = BeastNode.get_climb_path()
	
	Canvas_Layer.show()
	GooblinController.reset()
	music_player.play()


func _hide_all_backgrounds():
	$Background/BackgroundParallax/CaveBackground.visible = false
	$Background/BackgroundParallax/FieldBackground.visible = false
	$Background/CeilingParallax/CaveCeiling.visible = false
	$Background/FloorParallax/CaveFloor.visible = false
	$Background/FloorParallax/FieldFloor.visible = false
	$Background/FloorParallax/DryFloor.visible = false
	$Background/FloorParallax.repeat_size.x = 1280

func _on_enemy_hurt():
	HealthBar.value = BeastNode.health
	CurrentHealthLabel.text = str(BeastNode.health)


func _on_gooblin_horde_controller_gooblin_extinction():
	#calculate gold earned
	var percent_damage_dealt = 1.0 - (BeastNode.health / BeastNode.max_health)
	var gold_earned = round(percent_damage_dealt * BeastNode.get_gold_value())
	print("earned ", gold_earned, " gold")
	GooblinUpgrades.gold += gold_earned
	GooblinController.active = false
	DefeatPanel.update_gold_earned(gold_earned)
	DefeatPanel.show()

func _on_beast_died():
	var gold_earned = BeastNode.get_gold_value()
	GooblinUpgrades.gold += gold_earned
	if(GooblinUpgrades.levels_completed <= active_loaded_level):
		GooblinUpgrades.levels_completed = active_loaded_level + 1
	VictoryPanel.update_gold_earned(gold_earned)
	VictoryPanel.show()

func _on_return_button_pressed():
	GooblinController.end_level()
	Enemy.queue_free()
	Canvas_Layer.hide()
	DefeatPanel.hide()
	VictoryPanel.hide()
	emit_signal("ReturnFromCombat")
	GooblinController.kill_all()


func _on_retreat_button_pressed():
	click_player.play()
	GooblinController.kill_all()
