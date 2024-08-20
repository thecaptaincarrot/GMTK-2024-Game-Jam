extends Node

var save_path = "users://game_save.dat"


func save_game():
	var config_file = ConfigFile.new()
	config_file.set_value("App","Gold", gold)
	config_file.set_value("App","GooblinCount", gooblin_count)
	
	var err = config_file.save(save_path)
	#do something with the error

func load_game():
	var config_file = ConfigFile.new()
	var err = config_file.load(save_path)
	if(err):
		return
	gold = config_file.get_value("App", "Gold")
	gooblin_count = config_file.get_value("App", "GoblinCount")
	

func can_load():
	return FileAccess.file_exists(save_path)

#I guess we just have the one global, lol
var levels_completed = 0

var gooblin_count = 20 #Total gooblins of any class
#army composition
var basic_gooblins = 20
var shield_gooblins = 0
var climb_gooblins = 0
var catapult_gooblins = 0

var gold = 1000

#equipment totals:
var shields = 0
var hooks = 0

#Gooblin Upgrades
var gooblin_attack = 1
var gooblin_base_move_speed = 150.0
var gooblin_move_speed_upgrade_increment = 50.0 #how much each level of upgrade increases the gooblin's speed
var gooblin_speed_upgrade_level = 0

#Shieldbearer Upgrades
var shield_health = 1


#Scaler Upgrades
var damage_multiplier_level = 0
var base_damage_multiplier = 4.0

var base_climb_speed = 25.0
var climb_speed_level = 0
var climb_speed_increment = 25.0
var shake_off_chance = 0.50 #Chance to be shaken off when an enemy attacks

#Catapult Upgrades
#PLACEHOLDER
var gooblins_per_shot = 10
var reload_time = 5.0 #seconds


func check_gold(value):
	if gold >= value:
		return true
	return false


func gold_purchase(value):
	if gold >= value:
		gold -= value
		return true
	return false


#Gooblin Stat Getters
func get_gooblin_attack():
	return gooblin_attack


func get_next_googlin_attack():
	return gooblin_attack + 1


func get_gooblin_speed():
	return gooblin_base_move_speed + gooblin_speed_upgrade_level * gooblin_move_speed_upgrade_increment


func get_next_gooblin_speed():
	return gooblin_base_move_speed + (gooblin_speed_upgrade_level + 1) * gooblin_move_speed_upgrade_increment


func get_gooblin_shield_health():
	return shield_health


func get_next_gooblin_shield_health():
	return shield_health + 1


func get_scaler_multipler():
	return base_damage_multiplier + damage_multiplier_level


func get_next_scaler_multiplier():
	return base_damage_multiplier + damage_multiplier_level + 1


func get_scaler_climb_speed():
	return base_climb_speed + climb_speed_level * climb_speed_increment


func get_next_scaler_climb_speed():
	return base_climb_speed + (1 + climb_speed_level) * climb_speed_increment


#Cost curve calculation functions
func get_gooblin_attack_upgrade_cost():
	return 1000 * (pow(gooblin_attack,2))


func get_gooblin_speed_upgrade_cost():
	return 250 * pow(gooblin_speed_upgrade_level + 1,2)


func get_gooblin_shield_upgrade_cost():
	return 400 * pow(shield_health,2)


func get_gooblin_scaler_mult_upgrade_cost():
	return 500 * pow((damage_multiplier_level + 1),2)


func get_gooblin_scaler_climb_speed_upgrade_cost():
	return 500 * pow((climb_speed_level + 1),2)
