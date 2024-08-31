extends GenericState

@export var track_height := 250


func enter(_msg):
	beast.random_target_timer.start()

# this function is connected to the timeout of the randomtarget timer (most IdleStates do this)
# the attack_to_do picks what to deliberate. 0 is bite, 1 is stomp, 2 is nothing
# further along the function, there's another check with attack_chance that decides if the dragon will do
#what it is deliberating on and swaps into the appropriate state if it chooses to
func target_and_attack():
	if randi_range(1,beast.attack_chance) == 1:
		print("gonna atack")
		# if it is going to attack, you shouldn't start the timer until after the attack is done
		beast.random_target_timer.stop()
		
		var attack_choice
		if randf_range(0, 100) <= beast.get_parent().bite_chance_percent:
			attack_choice = "BiteState"
		else:
			attack_choice = "StompState"
		print(attack_choice)
		state_machine.change_to_state(attack_choice)

func exit():
	pass

