extends Node

enum Jump_State {PRE_JUMP, JUMPING, NONE, JUMP_STATES_COUNT}
static var jump_state: Jump_State = Jump_State.NONE

@onready var pre_jump: Node = $Pre_Jump
@onready var jumping: Node = $Jumping
@onready var state_machine: Node = get_parent()

@onready var dash: Node = get_node("../Dash")

@onready var coyote_jump: Node = $CoyoteJump
@onready var player_node: CharacterBody2D = find_parent("Player")


func is_triggered() -> bool:
	if (Input.is_action_just_pressed(PlayerConstants.JUMP_ACTION_NAME)):
		if (player_node.is_on_floor() or coyote_jump.is_coyote_jump_available()):
			return true
		else:
			state_machine.buffer_state(state_machine.States.JUMP)

	return false


func start():
	jump_state = Jump_State.PRE_JUMP
	print("jump start ", jump_state)




func get_to_next_state():
	if jump_state == Jump_State.PRE_JUMP:
		jumping.start()
		jump_state = Jump_State.JUMPING

	elif jump_state == Jump_State.JUMPING:
		state_machine.push_state(state_machine.States.IDLE)
		jump_state = Jump_State.NONE


	elif jump_state == Jump_State.NONE:  # ??
		jump_state = Jump_State.PRE_JUMP


func physics_process(delta: float, player: CharacterBody2D):
	print(jump_state)
	match (jump_state):
		Jump_State.PRE_JUMP:
			pre_jump.physics_process(delta, player)

		Jump_State.JUMPING:
			jumping.physics_process(delta, player)

		Jump_State.NONE:  # isn't supposed to happen
			print("Jump in NONE state, not supposed to happen")


	if (dash.is_triggered()):
		state_machine.push_state(state_machine.States.DASH)


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





