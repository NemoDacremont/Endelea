extends Node

enum Jump_State {PRE_JUMP, JUMPING, NONE, JUMP_STATES_COUNT}
static var jump_state: Jump_State = Jump_State.NONE

@onready var pre_jump: Node = $Pre_Jump
@onready var jumping: Node = $Jumping
@onready var state_machine: Node = get_parent()
static var player_node: CharacterBody2D


func is_triggered(player: CharacterBody2D) -> bool:
	if (player.is_on_floor()):
		return Input.is_action_just_pressed(PlayerConstants.JUMP_ACTION_NAME)

	return false


func start(player: CharacterBody2D):
	jump_state = Jump_State.PRE_JUMP
	player_node = player



func get_to_next_state():
	if jump_state == Jump_State.PRE_JUMP:
		jumping.start()
		jump_state = Jump_State.JUMPING

	elif jump_state == Jump_State.JUMPING:
		state_machine.state = state_machine.States.IDLE
		jump_state = Jump_State.NONE


	elif jump_state == Jump_State.NONE:  # ??
		jump_state = Jump_State.PRE_JUMP


func physics_process(delta: float, player: CharacterBody2D):
	match (jump_state):
		Jump_State.PRE_JUMP:
			pre_jump.physics_process(delta, player)
			pass

		Jump_State.JUMPING:
			jumping.physics_process(delta, player)
			pass

		Jump_State.NONE:  # isn't supposed to happen
			print("Jump in NONE state, not supposed to happen")
			pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(_delta: float, _player: CharacterBody2D):
	pass





