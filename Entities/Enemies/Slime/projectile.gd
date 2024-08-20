extends RigidBody2D

@export var damage := 10
@export var non_lethal_damage := 10

func _ready():
	position.y -= 140
	apply_impulse(Vector2(randi_range(-.5,.5), -randi_range(.5,1)) * 1000, Vector2(0,-100))


func _physics_process(delta: float) -> void:
	rotation = linear_velocity.angle()


func _on_body_entered(body: Node) -> void:
	hurt_gooblins()
	queue_free()

func hurt_gooblins():
	#placeholder
	print("projectile hurting gooblins now!")
