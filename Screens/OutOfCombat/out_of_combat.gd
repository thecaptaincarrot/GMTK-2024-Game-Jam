extends Control

signal go_to_combat

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	Texture.


func _on_to_combat_button_pressed() -> void:
	var level = 0
	emit_signal("go_to_combat",level)
