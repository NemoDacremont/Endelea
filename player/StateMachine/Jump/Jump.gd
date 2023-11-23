extends Node

# states
enum Jump_State {
	PRE_JUMP,
	JUMPING,
	NONE
}

static var jump_state: Jump_State = Jump_State.NONE


# Nodes
## States nodes
@onready var pre_jump: Node = $Pre_Jump
@onready var jumping: Node = $Jumping


## Jump specific nodes
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var coyote_jump: Node = $CoyoteJump

## import dash to override jump state if triggered
@onready var dash: Node = get_node("../Dash")

## state_machine to change  state
@onready var state_machine: Node = get_parent()

## Player to get collision information
@onready var player_node: CharacterBody2D = find_parent("Player")


func is_triggered() -> bool:
	"""
		Returns true if the jump key is pressed and jump is possible, returns false otherwise

		if can't jump but key is pressed, buffer jump in state_machine
	"""
	if (Input.is_action_just_pressed(PlayerConstants.JUMP_ACTION_NAME)):
		if (player_node.is_on_floor() or coyote_jump.is_coyote_jump_available()):
			return true

		# At least tries to buffer
		else:
			state_machine.buffer_state(state_machine.States.JUMP)
			jump_buffer_timer.start(PlayerConstants.STATE_BUFFER_TIMER_DURATION)

	return false



func can_start() -> bool:
	"""
		Returns true if can use the start method
	"""
	return player_node.is_on_floor() or coyote_jump.is_coyote_jump_available()


func start() -> void:
	"""
		Used when changind state, it'll make coyote unavailable and
		set the right jump state machine initial state
	"""
	jump_state = Jump_State.PRE_JUMP
	pre_jump.start()
	coyote_jump.force_coyote_availability(false)


# Works like a small state machine
func get_to_next_state():
	"""
		State machien doing stuff
		PRE_JUMP -> JUMPING -> NONE (and pushes idle state to state_machine so it exits jump state)
	"""
	if jump_state == Jump_State.PRE_JUMP:
		jump_state = Jump_State.JUMPING
		jumping.start()

	elif jump_state == Jump_State.JUMPING:
		jump_state = Jump_State.NONE
		state_machine.push_state(state_machine.States.IDLE)


	elif jump_state == Jump_State.NONE:  # ??
		jump_state = Jump_State.PRE_JUMP


func physics_process(delta: float, player: CharacterBody2D):
	match (jump_state):
		Jump_State.PRE_JUMP:
			pre_jump.physics_process(delta, player)

		Jump_State.JUMPING:
			jumping.physics_process(delta, player)

		Jump_State.NONE:  # isn't supposed to happen
			print("Jump in NONE state, not supposed to happen")


	if (dash.is_triggered()):  # override jump state if dash is used
		state_machine.push_state(state_machine.States.DASH)

	elif (is_triggered()):  # buffer jump if needed
		state_machine.push_state(state_machine.States.JUMP)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(_delta: float, _player: CharacterBody2D):
	match (jump_state):
		Jump_State.PRE_JUMP:
			pre_jump.process()

		Jump_State.JUMPING:
			jumping.process()

		Jump_State.NONE:  # isn't supposed to happen
			pass



func background_process():
	coyote_jump.physics_process()


# When the buffered action is triggered, stop the timer so it won't interfere with next jumps
func stop_buffer_timer():
	jump_buffer_timer.stop()


func _on_jump_buffer_timer_timeout():
	state_machine.clear_buffer(state_machine.States.JUMP)


