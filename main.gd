extends Node

#references
@export var CombatScreen : Node2D
@export var OutOfCombatScreen : Control
@export var MainMenu : Control
@export var Credits : Control


func _process(delta):
	if $CanvasLayer/OpeningCutscene/AnimationPlayer.is_playing() and Input.is_action_pressed("ui_cancel"):
		$CanvasLayer/OpeningCutscene/AnimationPlayer.stop()
		$CanvasLayer/OpeningCutscene/AudioStreamPlayer.stop()
		cutscene_over()


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
	$CanvasLayer/OpeningCutscene/AnimationPlayer.play("Cutscene")
	$CanvasLayer/MainMenu/Spawner.hide()
	$CanvasLayer/OpeningCutscene.show()


func cutscene_over():
	_hide_all()
	$CanvasLayer/OpeningCutscene.hide()
	OutOfCombatScreen.visible =true
	OutOfCombatScreen.reset_to_default()


func _on_main_menu_credits():
	Credits.restart()
	Credits.show()



func _on_combat_screen_final_credits():
	Credits.restart()
	Credits.show()
