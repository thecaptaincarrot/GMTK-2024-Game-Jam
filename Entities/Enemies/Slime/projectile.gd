extends RigidBody2D

@export var damage := 4
@export var non_lethal_damage := 10

@export var projectile_impulse_scalar = 1000

var intersecting_goobs = []

func _ready():
	apply_impulse(projectile_impulse_scalar * Vector2(randf_range(-.5,.25),-1))


func _physics_process(delta: float) -> void:
	rotation = linear_velocity.angle()


func _on_body_entered(body: Node) -> void:
	hurt_gooblins()
	queue_free()

func hurt_gooblins():
	pass
	if len(intersecting_goobs) == 0:
		return
	
	var to_hurt = damage
	
	var num_shields = 0
	var shield_goobs = []
	for goob in intersecting_goobs:
		if goob.unit_type == goob.GooblinType.SHIELD:
			shield_goobs.append(goob)
			num_shields += goob.shield_health
	
	#assign to shields first
	if num_shields > 0:
		for i in range(0,damage):
			var unlucky_goob = shield_goobs.pick_random()
			unlucky_goob.hurt()
			if unlucky_goob.shield_health <= 0:
				shield_goobs.erase(unlucky_goob)
			to_hurt -= 1
			num_shields -= 1
			if num_shields <= 0:
				break
	for i in range(0,to_hurt):
		var unlucky_goob = intersecting_goobs.pick_random()
		intersecting_goobs.erase(unlucky_goob)
		unlucky_goob.hurt()
		if len(intersecting_goobs) == 0:
			return


func flingerize_gooblins():
	if len(intersecting_goobs) == 0:
		return
	var to_fling = non_lethal_damage
	for goob in intersecting_goobs:
		goob.fling()
		to_fling -= 1
		if to_fling <=0:
			break


func _on_gooblin_detector_body_entered(body):
	if body is Gooblin:
		intersecting_goobs.append(body)


func _on_gooblin_detector_body_exited(body):
	if body in intersecting_goobs:
		intersecting_goobs.append(body)
