extends Node

signal reset_dash

#
#  Var / Consts
#

@onready var player: CharacterBody2D = find_parent("Player")

# State machine scripts
@onready var dash: Node = $Dash
@onready var jump: Node = $Jump
@onready var wall_jump: Node = $WallJump
@onready var idle: Node = $Idle

# 
@onready var coyote_jump: Node = find_child("CoyoteJump")

@onready var state_buffer_timer: Timer = $StateBufferTimer

# States
enum States {
	DASH,
	JUMP,
	WALL_JUMP,
	IDLE,
}

const STATES_NAME = [
	"Dash",
	"Jump",
	"Wall jump",
	"Idle"
]


var state: States = States.IDLE
static var state_buffer: States = States.IDLE

static var dash_counter: int = 0


#
#  Functions
#
func capture_inputs():
	pass


func buffer_state(_state: States):
	state_buffer = _state
	state_buffer_timer.start(PlayerConstants.STATE_BUFFER_TIMER_DURATION)


func get_to_next_state() -> void:
	state = state_buffer
	state_buffer = States.IDLE


func push_state(new_state: States) -> void:
	print("push(", STATES_NAME[new_state], ")")
	match (new_state):
		States.DASH:
			# Dash only if possible
			print("Dahh! counter=  ", dash_counter)
			if (dash_counter >= PlayerConstants.MAX_DASH_COUNTER):
				return

			dash_counter += 1
			dash.start()
			state = States.DASH

		States.JUMP:
			jump.start()
			coyote_jump.force_coyote_availability(false)
			state = new_state


		States.WALL_JUMP:
			wall_jump.start()
			state = new_state

		States.IDLE:
			if (state_buffer == States.IDLE):
				state = state_buffer
			else:
				print("use buffer! ", state_buffer)
				push_state(state_buffer)
				state_buffer = States.IDLE
				state_buffer_timer.stop()




func physics_process(delta):
	coyote_jump.physics_process()

	if (player.is_on_floor() or player.is_on_wall()):
		if (dash_counter != 0):
			emit_signal("reset_dash")

	match (state):
		States.DASH:
			dash.physics_process(delta, player)

		States.JUMP:
			jump.physics_process(delta, player)

		States.WALL_JUMP:
			wall_jump.physics_process(delta, player)

		States.IDLE:
			idle.physics_process(delta, player)


func process(delta):
	# print(STATES_NAME[state])

	match (state):
		States.DASH:
			dash.process(delta, player)

		States.JUMP:
			jump.process(delta, player)

		States.WALL_JUMP:
			wall_jump.process(delta, player)
			pass

		States.IDLE:
			idle.process(delta, player)


func _on_reset_dash():
	print("Reset dash!")
	dash_counter = 0




func _on_state_buffer_timer_timeout():
	print("Clear buffer: ", state_buffer)
	state_buffer = States.IDLE

