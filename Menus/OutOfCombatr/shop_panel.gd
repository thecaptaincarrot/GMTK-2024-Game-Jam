extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	update_gold() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_gold():
	$GoldContainer/Gold.text = str(GooblinUpgrades.gold)


func update_total_gooblins():
	$GooblinInfoContainer/TotalGooblinContainer/TotalGooblins.text = str(GooblinUpgrades.gooblin_count)
