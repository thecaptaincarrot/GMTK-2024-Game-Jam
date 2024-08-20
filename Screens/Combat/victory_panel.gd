extends Panel

@export var VictoryTitle : Label

@export var GoldLabel : Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if visible:
		VictoryTitle.position = Vector2(randi_range(-1,1),randi_range(-1,1))


func update_gold_earned(gold):
	GoldLabel.text = str(gold)
