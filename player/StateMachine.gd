extends Node

#
#  Var / Consts
#
@onready var player: CharacterBody2D = find_parent("Player")

# State machine scripts
@onready var dash: Node = $Dash
@onready var jump: Node = $Jump
@onready var wall_jump: Node = $WallJump
@onready var idle: Node = $Idle

# States
enum States {
	DASH,
	WALL_JUMP,
	JUMP,
	IDLE,
}

const STATES_NAME = [
	"Dash",
	"Wall jump",
	"Jump",
	"Idle"
]


@onready var states_nodes = [
	dash,
	wall_jump,
	jump,
	idle
]


# State management vars
static var state: States = States.IDLE
static var tmp_state: States = States.IDLE
static var state_buffer: States = States.IDLE  # Used

# State Buffer (TODO)
@onready var state_buffer_timer: Timer = $StateBufferTimer


#
#  Functions
#
func buffer_state(_state: States):
	state_buffer = _state


func clear_buffer(state_to_clear: States):
	if (state_buffer == state_to_clear):
		state_buffer = States.IDLE


func get_to_next_state() -> void:
	state = state_buffer
	state_buffer = States.IDLE


func push_state(new_state: States) -> void:
	if (state_buffer < state && state_buffer < new_state && states_nodes[state_buffer].can_start()):
		print("buffered: ", STATES_NAME[state_buffer])
		new_state = state_buffer
		buffer_state(States.IDLE)

	if (states_nodes[new_state].can_start()):
		states_nodes[new_state].start()
		state = new_state

	# match (new_state):
	# 	States.DASH:
	# 		dash.start()
	# 		state = States.DASH
	#
	#
	# 	States.WALL_JUMP:
	# 		wall_jump.start()
	# 		state = new_state
	#
	#
	# 	States.JUMP:
	# 		jump.start()
	# 		state = new_state
	#
	#
	# 	States.IDLE:
	# 		if (state_buffer == States.IDLE):
	# 			state = state_buffer
	#
	# 		elif jump.can_start():
	# 			tmp_state = state_buffer  # Need to use this to avoid call cycle
	# 			state_buffer = States.IDLE
	# 			state_buffer_timer.stop()
	# 			push_state(tmp_state)


func physics_process(delta):
	states_nodes[state].physics_process(delta, player)

	# Background tasks like dash reset
	for node in states_nodes:
		node.background_process()


func process(delta):
	states_nodes[state].process(delta, player)


func _on_state_buffer_timer_timeout():
	state_buffer = States.IDLE



