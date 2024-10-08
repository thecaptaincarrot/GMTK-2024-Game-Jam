extends Panel

@export var click_sound : AudioStreamPlayer

#label references
@export var available_gooblins_label : Label

@export var available_shields_label : Label

@export var available_hook_label : Label

#Spinbox References
@export var shield_gooblin_spinbox : SpinBox

@export var hook_gooblin_spinbox : SpinBox

# Called when the node enters the scene tree for the first time.
func _ready():
	update_all() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#updates
func update_available_gooblins(): #THIS MUST ALWAYS BE DONE FIRST AND I'M SORRY ABOUT THAT
	GooblinUpgrades.basic_gooblins = GooblinUpgrades.gooblin_count - GooblinUpgrades.shield_gooblins - GooblinUpgrades.climb_gooblins
	available_gooblins_label.text = str(GooblinUpgrades.basic_gooblins)


func update_shield_gooblins_controls(): #THIS DOES NOT CHANGE THE ACTUAL NUMBER OF SHIELD GOOBLINS
	shield_gooblin_spinbox.max_value = GooblinUpgrades.shield_gooblins + min(GooblinUpgrades.basic_gooblins,GooblinUpgrades.shields - GooblinUpgrades.shield_gooblins)
	shield_gooblin_spinbox.value = GooblinUpgrades.shield_gooblins
	available_shields_label.text = str(GooblinUpgrades.shields - GooblinUpgrades.shield_gooblins)


func update_hook_gooblins_controls():
	hook_gooblin_spinbox.max_value = GooblinUpgrades.climb_gooblins + min(GooblinUpgrades.basic_gooblins,GooblinUpgrades.hooks - GooblinUpgrades.climb_gooblins)
	hook_gooblin_spinbox.value = GooblinUpgrades.climb_gooblins
	available_hook_label.text = str(GooblinUpgrades.hooks - GooblinUpgrades.climb_gooblins)


func update_all():
	update_available_gooblins()
	update_shield_gooblins_controls()
	update_hook_gooblins_controls()

#signal responses
func _on_shield_spinbox_value_changed(value):
	GooblinUpgrades.shield_gooblins = value
	update_all()


func _on_scalers_spinbox_value_changed(value):
	GooblinUpgrades.climb_gooblins = value
	update_all()
