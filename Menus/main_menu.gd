extends Control


func _ready():
	if(!GooblinUpgrades.can_load()):
		$VBoxContainer/Continue.disabled = true

func _on_continue_pressed() -> void:
	GooblinUpgrades.load()
	get_parent().get_parent().show_out_of_combat_screen()


func _on_new_run_pressed() -> void:
	get_parent().get_parent().show_out_of_combat_screen()


func _on_quit_pressed() -> void:
	get_tree().quit()
