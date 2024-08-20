extends Panel

signal level_changed

@export var click_sound : AudioStreamPlayer

@export var map_line_0 : TextureRect
@export var map_line_1 : TextureRect
@export var map_line_2 : TextureRect
@export var map_line_3 : TextureRect

@export var level_button_0 : TextureButton
@export var level_button_1 : TextureButton
@export var level_button_2 : TextureButton
@export var level_button_3 : TextureButton
@export var level_button_4 : TextureButton

var map_lines = []
var level_buttons = []

# Called when the node enters the scene tree for the first time.
func _ready():
	map_lines = [map_line_0, map_line_1, map_line_2, map_line_3]
	level_buttons = [level_button_0,level_button_1,level_button_2,level_button_3,level_button_4]
	
	for line in map_lines:
		line.hide()
	for button in level_buttons:
		button.hide()
	update_level_options()
	
	level_button_0.button_pressed = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_level_options():
	var levels_complete = GooblinUpgrades.levels_completed
	if levels_complete < 5: ## added this line because it crashes after beating the dragon otherwise
		for i in range(0,levels_complete + 1):
			level_buttons[i].show()
		for i in range(0,levels_complete):
			map_lines[i].show()


func _on_level_button_0_pressed():
	level_button_0.button_pressed = true
	level_button_1.button_pressed = false
	level_button_2.button_pressed = false
	level_button_3.button_pressed = false
	level_button_4.button_pressed = false
	emit_signal("level_changed",0)
	click_sound.play()

func _on_level_button_1_pressed():
	level_button_0.button_pressed = false
	level_button_1.button_pressed = true
	level_button_2.button_pressed = false
	level_button_3.button_pressed = false
	level_button_4.button_pressed = false
	emit_signal("level_changed",1)
	click_sound.play()

func _on_level_button_2_pressed():
	level_button_0.button_pressed = false
	level_button_1.button_pressed = false
	level_button_2.button_pressed = true
	level_button_3.button_pressed = false
	level_button_4.button_pressed = false
	emit_signal("level_changed",2)
	click_sound.play()


func _on_level_button_3_pressed():
	level_button_0.button_pressed = false
	level_button_1.button_pressed = false
	level_button_2.button_pressed = false
	level_button_3.button_pressed = true
	level_button_4.button_pressed = false
	emit_signal("level_changed",3)
	click_sound.play()


func _on_level_button_4_pressed():
	level_button_0.button_pressed = false
	level_button_1.button_pressed = false
	level_button_2.button_pressed = false
	level_button_3.button_pressed = false
	level_button_4.button_pressed = true
	emit_signal("level_changed",4)
	click_sound.play()
