extends PanelContainer

@export var txtrect: TextureRect
@export var beast_name: Label
@export var beast_text: Label
@export var beast_second_text: Label
var boss = preload("res://Screens/Combat/combat_screen.gd")
#enum BeastTexture{
	#KNIGHT: preload("res://Screens/Credits/gooobknight_transparent.png"),
	#GIANT: preload("res://Screens/Credits/goobercyclops_transparent.png"),
	#SLIME: preload(""),
	#STONEJAW: preload("res://Screens/Credits/stonejaw.png"),
	#DRAGON: preload("res://Screens/Credits/gooberdragon_transparent.png")
#}

func _ready():
	_on_map_panel_level_changed(0)


func _on_map_panel_level_changed(lvl) -> void:
	var new_beast: Array
	match lvl:
		0:
			new_beast = [
				"Knight-Errant of Diaz",
				"HEALTH: Equivalent to snapping %s twigs\n
				HEIGHT: About one horse\n
				WEIGHT: Definitely lighter than a horse\n
				FEATURES:\n
				\t- Dangerous mace (possibly anti-Gooblin)\n
				\t- Human legs (kicks up a storm)",
				"It seems this knight has been around a while... What are those streaks on their mace and armor?"
			]
		1:
			new_beast = [
				"Giant Mercenary",
				"HEALTH: Equivalent to throwing %s pebbles\n
				HEIGHT: Two or three humans\n
				WEIGHT: Earth-shaking\n
				EYES: One\n
				FEATURES:\n
				\t- Huge club\n
				\t- Giant legs",
				"Bears the same symbol as the Knight-Errant. Odd shape, that..."
			]
		2:
			new_beast = [
				"Gelatinous Mass",
				"HEALTH: Equivalent to pushing %s snails\n
				HEIGHT: Pine tree\n
				WEIGHT: Surprisingly light (and aerodynamic)\n
				GOOP: Unclimbable\n
				FEATURES:\n
				\t- Lodged bones (will they come off if we hit them?)",
				"No Gooblin wants to begin to think what would happen if they got stuck inside this thing..."
			
			]
		3: new_beast = [
			"Stonejaw Wyrm",
			"HEALTH: Equivalent to wrestling %s beetles\n
			HEIGHT: Many, many boulders\n
			WEIGHT: Mountainous\n
			SYMBOL: There again\n
			FEATURES:\n
			\t- Stone jaw\n
			\t- Self-destructive mannerisms",
			"Does anyone know the difference between a wyrm and a worm..?"
			]
		4: new_beast = [
			"Kazan the Great",
			"HEALTH: A LOT\n
			HEIGHT: The entire hill we lived on\n
			WEIGHT: Imagine the Sun\n
			FEATURES:\n
			\t- Sharp teeth and a massive jaw\n
			\t- Claws of oblivion\n
			\t- You guys go on ahead I'll catch up",
			"The bully-dragon lays bare! Attack!"
			]
		_:
			print("OH NO!!")
	beast_name.text = new_beast[0]
	if lvl == 4: beast_text.text = new_beast[1]
	else: beast_text.text = new_beast[1] % boss.ENEMY_HEALTH[lvl] 
	beast_second_text.text = new_beast[2]
	
