extends Node

#references
@export var CombatScreen : Node2D
@export var OutOfCombatScreen : Control
@export var MainMenu : Control
@export var Credits : Control

func show_out_of_combat_screen():
	_hide_all()
	OutOfCombatScreen.visible = true


func show_main_menu():
	_hide_all()
	MainMenu.visible = true


func _hide_all():
	OutOfCombatScreen.visible = false
	MainMenu.visible = false
	#Credits.visible = false
	CombatScreen.visible = false


func _on_out_of_combat_go_to_combat(level : int):
	_hide_all()
	CombatScreen.load_level(level)
	CombatScreen.visible = true


func _on_combat_screen_return_from_combat():
	_hide_all()
	OutOfCombatScreen.reset_to_default()
	OutOfCombatScreen.visible =true


func _on_main_menu_new_game():
	_hide_all()
	OutOfCombatScreen.reset_to_default()
	OutOfCombatScreen.visible =true
