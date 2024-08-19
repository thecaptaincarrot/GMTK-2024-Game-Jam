extends Control

signal go_to_combat

@export var background_texture : TextureRect

@export var background_scroll_divider = 10

@export var shop_control : Panel

@export var planning_menus : Control
@export var army_comp_panel : Panel
@export var army_display : Node2D

@export var map_panel : Panel

@export var combat_button : Button

var direction = -1

var level_selection = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	#if background_texture.texture is GradientTexture1D:
		#var offset_0 = background_texture.texture.gradient.get_offset(0)
		#background_texture.texture.gradient.set_offset(0,offset_0 - delta / background_scroll_divider)
		#
		#var offset_1 = background_texture.texture.gradient.get_offset(1)
		#
		#background_texture.texture.gradient.set_offset(1,offset_1 + direction * ( delta / background_scroll_divider)
	pass


func reset_to_default():
	shop_control.hide()
	shop_control.update_all()
	planning_menus.show()
	
	map_panel.update_level_options()



func _on_to_combat_button_pressed() -> void:
	emit_signal("go_to_combat",level_selection)


func _on_shop_button_pressed():
	planning_menus.hide()
	shop_control.update_all()
	shop_control.show()


func _on_return_button_pressed():
	planning_menus.show()
	shop_control.hide()


func _on_map_panel_level_changed(new_level):
	print("Switched to level: ", new_level)
	level_selection = new_level
