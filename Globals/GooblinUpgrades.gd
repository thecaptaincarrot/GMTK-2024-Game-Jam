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

var gooblin_count = 20

var gold = 0

#Gooblin Upgrades
var gooblin_attack = 1
var gooblin_move_speed = 300.0

#Shieldbearer Upgrades
var shield_health = 1


#Scaler Upgrades
#PLACEHOLDER
var damage_multiplier = 4.0
var climb_speed = 200.0
var shake_off_chance = 0.50 #Chance to be shaken off when an enemy attacks

#Catapult Upgrades
#PLACEHOLDER
var gooblins_per_shot = 10
var reload_time = 5.0 #seconds
