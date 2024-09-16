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
@export var TrueVictoryPanel:Panel

@export var FieldFloor : StaticBody2D
@export var CaveFloor : StaticBody2D

const FIELD_BG = 0
const CAVE_BG = 1
const DRY_BG = 2
const LAKE_BG = 3

signal final_credits

#Level Definitions
#Specifics for things like camera bounds, enemy type, other things are stored in an array
#Array indicies correspond to the level being entered.
#I.e. Level 0 will pull all relevant variables from arrays on index 0

const CAM_OFFSET = Vector2(640,360)

#Camera bounds always start at position 0,0 on upper left
const CAMERA_BOUNDS = [ Vector2(1400,900),
						Vector2(1400,900),
						Vector2(2400,950),
						Vector2(1900,900),
						Vector2(2000,950),
						] 

const ENEMY_SCENE = [ preload("res://Entities/Enemies/Knight/Knight.tscn"), 
					  preload("res://Entities/Enemies/Giant/Giant.tscn"), 
					  preload("res://Entities/Enemies/Slime/Slime.tscn"), 
					  preload("res://Entities/Enemies/Wyrm/wyrm.tscn"), 
					  preload("res://Entities/Enemies/Dragon/Dragon.tscn"),
					]


#const ENEMY_POS = [ Vector2(1100, 700),
					#Vector2(1100,730),
					#Vector2(1400,800),
					#Vector2(1500,800),
					#Vector2(1800,950),
					#]

const GOOBLIN_RANGE = [80,
					   128,
					   100,
					   100,
					   128,
					]

const ENEMY_HEALTH = [200,
					  700,
					  1300,
					  2800,
					  9999,
]

const ENEMY_REWARD = [1200,
					  6000,
					  8000,
					  10000,
					  50000,
					]

const BACKGROUND = [ FIELD_BG,
					 FIELD_BG,
					 CAVE_BG,
					 DRY_BG,
					 CAVE_BG
	
]


const FLOOR = [0,
				0,
				1,
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
	$CanvasLayer/RetreatButton.disabled = false
	active_loaded_level = level_index
	camera.limit_right = CAMERA_BOUNDS[level_index].x
	camera.limit_bottom = CAMERA_BOUNDS[level_index].y
	# set starting zoom
	camera.zoom = Vector2.ONE * 1.4
	
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
	
	GooblinController.horde_range = GOOBLIN_RANGE[level_index]
	
	camera.position = Vector2(0,camera.limit_bottom)
	
	Enemy = ENEMY_SCENE[level_index].instantiate()
	Enemy.horde_controller = GooblinController
	print(GooblinController)
	Enemy.position = Vector2(CAMERA_BOUNDS[level_index].x - 200, GooblinController.get_spawn_point().y)#ENEMY_POS[level_index]
	Enemy.get_node("Beast").max_health = ENEMY_HEALTH[level_index]
	Enemy.get_node("Beast").gold_value = ENEMY_HEALTH[level_index]
	add_child(Enemy)
	BeastNode = Enemy.enemy #haha that's a naming oops
	BeastNode.shake_screen.connect(camera.shake_screen)
	print(BeastNode)
	BeastNode.enemy_hurt.connect(_on_enemy_hurt)
	BeastNode.died.connect(_on_beast_died)
	BeastNode.shake_off_scalers.connect(GooblinController.shake_off_scalers)
	
	MaxHealthLabel.text = str(BeastNode.max_health)
	CurrentHealthLabel.text = str(BeastNode.max_health)
	HealthBar.max_value = BeastNode.max_health
	HealthBar.value = BeastNode.max_health
	
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
	var gold_earned = round(percent_damage_dealt * ENEMY_REWARD[active_loaded_level])
	print("earned ", gold_earned, " gold")
	GooblinUpgrades.gold += gold_earned
	GooblinController.active = false
	DefeatPanel.update_gold_earned(gold_earned)
	defeat_player.play()
	DefeatPanel.show()


func _on_beast_died():
	var gold_earned = ENEMY_REWARD[active_loaded_level]
	GooblinUpgrades.gold += gold_earned
	if(GooblinUpgrades.levels_completed <= active_loaded_level):
		GooblinUpgrades.levels_completed = active_loaded_level + 1
	GooblinController.celebrate()
	$CanvasLayer/RetreatButton.disabled = true
	victory_player.play()
	VictoryPanel.update_gold_earned(gold_earned)
	if active_loaded_level == 4:
		TrueVictoryPanel.update_gold_earned(gold_earned)
		TrueVictoryPanel.show()
	else:
		VictoryPanel.show()


func _on_return_button_pressed():
	music_player.stop()
	GooblinController.end_level()
	Enemy.queue_free()
	Canvas_Layer.hide()
	DefeatPanel.hide()
	VictoryPanel.hide()
	TrueVictoryPanel.hide()
	emit_signal("ReturnFromCombat")
	GooblinController.kill_all()


func _on_retreat_button_pressed():
	click_player.play()
	defeat_player.stop()
	victory_player.stop()
	GooblinController.kill_all()


func _on_true_victory_return_button_pressed():
	music_player.stop()
	GooblinController.end_level()
	Enemy.queue_free()
	Canvas_Layer.hide()
	DefeatPanel.hide()
	VictoryPanel.hide()
	TrueVictoryPanel.hide()
	emit_signal("final_credits")
	emit_signal("ReturnFromCombat")
	GooblinController.kill_all()


func _on_debug_panel_win():
	if !Enemy:
		return
	else:
		BeastNode.die()


func _on_debug_panel_spawn_gooblings(num):
	GooblinController.basic_to_spawn += num


func _on_debug_panel_spawn_scalers(num):
	GooblinController.scaler_to_spawn += num


func _on_debug_panel_spawn_shields(num):
	GooblinController.shield_to_spawn += num


func _on_debug_panel_update_menus():
	#not needed yet
	pass # Replace with function body.
