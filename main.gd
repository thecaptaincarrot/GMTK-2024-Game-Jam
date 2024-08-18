extends Node

func show_out_of_combat_screen():
	_hide_all()
	$CanvasLayer/OutOfCombat.visible = true


func show_main_menu():
	_hide_all()
	$CanvasLayer/MainMenu.visible = true

func show_test_stage():
	_hide_all()
	$TestStage.visible = true

func _hide_all():
	$TestStage.visible = false
	$CanvasLayer/OutOfCombat.visible = false
	$CanvasLayer/MainMenu.visible =false
