extends Node

## Adaptable Finite State Machine

# You can instantiate the state_machine.tscn to get a fsm easily
# I don't think there's going to be a need to create more types of state machines
# Since functionality is delegated to the states and their methods are universal

@export var hit_sound_player : AudioStreamPlayer

## Don't forget to set the initial_state from the editor! This is critical!
@export var initial_state: NodePath
@onready var current_state = get_node(initial_state)

signal state_changed(to: String)
var previous_state: Node

@export var on = true

## Change this variable to log every state change in output
@export var log_changes := true



func _ready():
	for n in get_children():
		n.screen_shake.connect(get_parent()._on_state_machine_shake_screen)
		n.shake_off.connect(get_parent()._on_state_machine_shake_off_scalers)
		n.hit_sound_player = hit_sound_player
	
	if initial_state and on:
		# swap into the the default state first thing
		call_deferred("change_to_state", initial_state)


func _unhandled_input(event: InputEvent):
	if initial_state and on:
		current_state.handle_input(event)


func _process(delta: float):
	if initial_state and on:
		current_state.update(delta)


func _physics_process(delta: float):
	if initial_state and on:
		current_state.physics_update(delta)


func change_to_state(state: String, msg = {}):
	if on:
		# Log previous state first
		previous_state = current_state

		# Call exit function on previous state
		#if an error is thrown out here it's probably because the initial_state wasn't set properly
		current_state.exit()

		# Swap into new state (pass the NODE NAME of the state you want to change to)
		if find_child(state) == null:
			prints('"', state, '"', "DOES NOT EXIST" )
			return
		else:
			current_state = get_node(state)
		
		# Call enter function on new state, pass a message to inform new state if needed (the message can be anything)
		current_state.enter(msg)

		# Emit signal
		state_changed.emit(state)
		#if log_changes:
			#prints(owner.get_parent().name, "changed to", current_state.name)
