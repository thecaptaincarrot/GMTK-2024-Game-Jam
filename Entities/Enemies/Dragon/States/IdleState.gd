extends GenericState

@export var head_pointer: Node2D

@export var stomp_range := 600

@export var track_height := 100

func _ready():
	beast.target_changed.connect(_on_target_changed)
	beast.attack_call.connect(_on_attack_call)

#func enter(_msg):
	#pass
	#print("dragon")

#func handle_input(event):
	#pass

#func update(_delta):
	#pass

#func physics_update(_delta):
	#pass

#func exit():
	#pass

var tween

func _on_target_changed(target):
	if get("head_pointer") and beast.get("current_target"):
		tween = get_tree().create_tween()
		tween.tween_property(head_pointer,"global_position" , target.get_global_position() - Vector2(0, track_height), beast.random_target_timer.wait_time).set_trans(Tween.TRANS_SINE)
		#head_pointer.set_global_position(beast.current_target.get_global_position())

func _on_attack_call(target):
	print("gonna atack")
	await tween.finished
	if target.global_position.x < beast.global_position.x - stomp_range:
		state_machine.change_to_state("BiteState")
	else:
		state_machine.change_to_state("StompState")
