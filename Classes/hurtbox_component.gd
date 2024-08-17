extends Area2D
## Dynamic hurtboxes for beast

# Assign the "Sprites" node here to get a clean reference!!
@export var sprites: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for sprite in sprites.get_children():
		var rectangle = RectangleShape2D.new()
		rectangle.size = sprite.get_rect().size
		var new_collider = CollisionShape2D.new()
		new_collider.shape = rectangle
		# this is important. trust
		new_collider.debug_color = Color("green", 0.5)
		sprite.add_child(new_collider)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
