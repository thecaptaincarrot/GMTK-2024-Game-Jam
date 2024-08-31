extends Timer

@export var state_machine: Node
@export var go_to_state := "IdleState"

func _ready() -> void:
	state_machine.state_changed.connect(_on_state_changed)
	
func _on_state_changed(_new_state):
	start(wait_time)

func _on_timeout():
	if not get_parent().dead and state_machine.current_state.name != "IdleState":
		print("assuming direct control")
		state_machine.change_to_state(go_to_state)
