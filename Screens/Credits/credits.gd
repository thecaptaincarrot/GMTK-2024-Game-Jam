extends Control

signal credits_over

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		end_credits()

func restart():
	$CreditsOver.start()
	$CreditsPlayer.stop()
	$CreditsPlayer.play("RollCredits")


func end_credits():
	$CreditsOver.stop()
	emit_signal("credits_over")
	hide()
