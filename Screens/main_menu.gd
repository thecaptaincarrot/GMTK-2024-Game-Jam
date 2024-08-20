extends Control

signal NewGame
signal Continue
signal Credits

@export var click_player : AudioStreamPlayer

@export var spawner: Node2D

func _ready():
	if(!GooblinUpgrades.can_load()):
		$VBoxContainer/Continue.disabled = true

func _on_continue_pressed() -> void:
	GooblinUpgrades.load()
	click_player.play()
	emit_signal("Continue")
	


func _on_new_run_pressed() -> void:
	click_player.play()
	emit_signal("NewGame")


func _on_quit_pressed() -> void:
	click_player.play()
	get_tree().quit()


func _on_credits_pressed():
	click_player.play()
	spawner.hide()
	emit_signal("Credits")


func _on_credits_credits_over():
	spawner.show()
