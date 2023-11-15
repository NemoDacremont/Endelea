extends Node

enum Jump_State {PRE_JUMP, JUMPING, NONE, JUMP_STATES_COUNT}
static var jump_state: Jump_State = Jump_State.NONE

@onready var pre_jump: Node = $Pre_Jump
@onready var jumping: Node = $Jumping
@onready var state_machine: Node = get_parent()

@onready var dash: Node = get_node("../Dash")

@onready var coyote_jump: Node = $CoyoteJump
@onready var player_node: CharacterBody2D = find_parent("Player")

@onready var jump_buffer_timer: Timer = $JumpBufferTimer


func is_triggered() -> bool:
	if (Input.is_action_just_pressed(PlayerConstants.JUMP_ACTION_NAME)):
		if (player_node.is_on_floor() or coyote_jump.is_coyote_jump_available()):
			return true
		else:
			state_machine.buffer_state(state_machine.States.JUMP)
			jump_buffer_timer.start(PlayerConstants.STATE_BUFFER_TIMER_DURATION)
			print("Buffer jumpp")

	return false


func can_start():
	return player_node.is_on_floor() or coyote_jump.is_coyote_jump_available()


func start():
	jump_state = Jump_State.PRE_JUMP
	coyote_jump.force_coyote_availability(false)


func get_to_next_state():
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


	if (dash.is_triggered()):
		state_machine.push_state(state_machine.States.DASH)

	elif (is_triggered()):
		state_machine.push_state(state_machine.States.JUMP)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(_delta: float, _player: CharacterBody2D):
	match (jump_state):
		Jump_State.PRE_JUMP:
			pre_jump.process()

		Jump_State.JUMPING:
			jumping.process()

		Jump_State.NONE:  # isn't supposed to happen
			# print("Jump in NONE state, not supposed to happen")
			pass


func background_process():
	coyote_jump.physics_process()


func _on_jump_buffer_timer_timeout():
	state_machine.clear_buffer(state_machine.States.JUMP)


