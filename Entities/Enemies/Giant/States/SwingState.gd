extends GenericState

@export var attacker: CollisionShape2D
@export var hitbox: Area2D

func enter(_msg):
	beast.random_target_timer.stop()
	attacker.disabled = false
	
	await beast.animation_player.animation_finished
	
	hurt_gooblins()
	
	state_machine.change_to_state("IdleState")

var intersecting_goobs := []
func physics_update(_delta):
	intersecting_goobs = hitbox.get_overlapping_bodies()

func exit():
	# once it's done
	attacker.disabled = true
	beast.random_target_timer.start()

func hurt_gooblins():
	for goob in intersecting_goobs:
		goob.hurt()
