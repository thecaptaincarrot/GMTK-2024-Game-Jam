extends Panel

#Signals
signal army_composition_update

#label references
@export var total_gooblin_label : Label
@export var gold_label : Label

@export var gooblin_current_attack_label : Label
@export var gooblin_next_attack_label : Label

@export var gooblin_current_speed_label : Label
@export var gooblin_next_speed_label : Label

@export var gooblin_current_shield_label : Label
@export var gooblin_next_shield_label : Label

#Button references
@export var one_gooblin_button : Button
@export var ten_gooblin_button : Button

@export var gooblin_attack_upgrade_button : Button
@export var gooblin_speed_upgrade_button : Button

@export var purchase_shield_button : Button
@export var shield_health_upgrade_button : Button

#Cost references
@export var cost_per_gooblin = 10
@export var cost_per_shield = 20
#NOTE: FOR COSTS OF UPGRADES, SEE EQUATION IN GooblinUpgrades


# Called when the node enters the scene tree for the first time.
func _ready():
	one_gooblin_button.text = str(cost_per_gooblin) + " gold"
	ten_gooblin_button.text = str(cost_per_gooblin * 10) + " gold"
	
	purchase_shield_button.text = str(cost_per_shield) + " gold"
	update_all() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#update labels
func update_gold():
	gold_label.text = str(GooblinUpgrades.gold)


func update_total_gooblins():
	total_gooblin_label.text = str(GooblinUpgrades.gooblin_count)


#update button text for new cost
func update_gooblin_attack():
	gooblin_attack_upgrade_button.text = str(GooblinUpgrades.get_gooblin_attack_upgrade_cost()) + " gold"
	gooblin_current_attack_label.text = str(GooblinUpgrades.get_gooblin_attack())
	gooblin_next_attack_label.text = str(GooblinUpgrades.get_next_googlin_attack())


func update_gooblin_speed():
	gooblin_speed_upgrade_button.text = str(GooblinUpgrades.get_gooblin_speed_upgrade_cost()) + " gold"
	gooblin_current_speed_label.text = str(GooblinUpgrades.get_gooblin_speed())
	gooblin_next_speed_label.text = str(GooblinUpgrades.get_next_gooblin_speed())


func update_gooblin_shield_health():
	shield_health_upgrade_button.text = str(GooblinUpgrades.get_gooblin_shield_upgrade_cost()) + " gold"
	gooblin_current_shield_label.text = str(GooblinUpgrades.get_gooblin_shield_health())
	gooblin_next_shield_label.text = str(GooblinUpgrades.get_next_gooblin_shield_health())


func update_all():
	update_gold()
	update_total_gooblins()
	update_gooblin_attack()
	update_gooblin_speed()
	update_gooblin_shield_health()
	emit_signal("army_composition_update")


#BUTTON SIGNAL FUNCTIONS
func _on_one_gooblin_button_pressed():
	if GooblinUpgrades.gold_purchase(10):
		GooblinUpgrades.gooblin_count += 1
	update_all()


func _on_ten_gooblin_button_pressed():
	if GooblinUpgrades.gold_purchase(100):
		GooblinUpgrades.gooblin_count += 10
	update_all()

#Basic Goolbin Upgrades

func _on_basic_gooblin_attack_up_button_pressed():
	if GooblinUpgrades.gold_purchase(GooblinUpgrades.get_gooblin_attack_upgrade_cost()):
		GooblinUpgrades.gooblin_attack += 1
		update_all()


func _on_basic_gooblin_speed_button_pressed():
	if GooblinUpgrades.gold_purchase(GooblinUpgrades.get_gooblin_speed_upgrade_cost()):
		GooblinUpgrades.gooblin_speed_upgrade_level += 1
		update_all()

#Shield Gooblin Upgrades
func _on_shield_purchase_button_pressed():
	if GooblinUpgrades.gold_purchase(cost_per_shield):
		GooblinUpgrades.shields += 1
		update_all()


func _on_shield_upgrade_button_pressed():
	if GooblinUpgrades.gold_purchase(GooblinUpgrades.get_gooblin_shield_upgrade_cost()):
		GooblinUpgrades.shield_health += 1
		update_all()
