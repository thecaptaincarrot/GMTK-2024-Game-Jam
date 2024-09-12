extends Panel

signal win

signal spawn_gooblings
signal spawn_shields
signal spawn_scalers
signal update_menus

@export var active := false

@export var GoldSpinbox :SpinBox
@export var GooblinSpinbox : SpinBox
@export var LevelSpinbox : SpinBox


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("debug") and active:
		if visible:
			hide()
		else:
			update_from_GooblinUpgrades()
			show()


func update_from_GooblinUpgrades():
	GoldSpinbox.value = GooblinUpgrades.gold
	GooblinSpinbox.value = GooblinUpgrades.gooblin_count
	LevelSpinbox.value = GooblinUpgrades.levels_completed


func _on_gold_spin_box_value_changed(value):
	GooblinUpgrades.gold = value
	update_menus.emit()


func _on_gooblin_spin_box_value_changed(value):
	GooblinUpgrades.gooblin_count = value
	update_menus.emit()


func _on_level_spinbox_value_changed(value):
	GooblinUpgrades.levels_completed = value
	update_menus.emit()


func _on_spawn_1_gooblin_pressed():
	spawn_gooblings.emit(1)


func _on_spawn_10_gooblin_pressed():
	spawn_gooblings.emit(10)


func _on_spawn_100_gooblin_pressed():
	spawn_gooblings.emit(100)


func _on_spawn_1_shield_pressed():
	spawn_shields.emit(1)


func _on_spawn_10_shield_pressed():
	spawn_shields.emit(10)


func _on_spawn_100_shield_pressed():
	spawn_shields.emit(100)


func _on_spawn_1_scaler_pressed():
	spawn_scalers.emit(1)


func _on_spawn_10_scaler_pressed():
	spawn_scalers.emit(10)


func _on_spawn_100_scaler_pressed():
	spawn_scalers.emit(100)


func _on_win_button_pressed():
	win.emit()


func _on_out_of_combat_go_to_combat(_garbage):
	$VBoxContainer/Combat.show()


func _on_combat_screen_return_from_combat():
	$VBoxContainer/Combat.hide()


func _on_close_pressed():
	hide()
