extends Control

signal NewGame
signal Continue

func _ready():
	if(!GooblinUpgrades.can_load()):
		$VBoxContainer/Continue.disabled = true

func _on_continue_pressed() -> void:
	GooblinUpgrades.load()
	emit_signal("Continue")


func _on_new_run_pressed() -> void:
	emit_signal("NewGame")


func _on_quit_pressed() -> void:
	get_tree().quit()
