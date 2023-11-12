extends Node


enum Wall_Jump_State {PRE_WALL_JUMP, WALL_JUMPING, NONE, WALL_JUMP_STATES_COUNT}
static var wall_jump_state: Wall_Jump_State = Wall_Jump_State.NONE

@onready var pre_wall_jump: Node = $PreWallJump
@onready var wall_jumping: Node = $WallJumping
@onready var state_machine: Node = get_parent()
static var player_node: CharacterBody2D

var wall_jump_direction: Vector2 = Vector2.UP


func is_triggered(player: CharacterBody2D) -> bool:
	if (player.is_on_wall_only()):
		# Wall jump to the right
		if (Input.is_action_pressed(PlayerConstants.MOVE_LEFT_ACTION_NAME)):
			wall_jump_direction = Vector2(1.5, -1)

		# Wall jump to the left
		elif (Input.is_action_pressed(PlayerConstants.MOVE_LEFT_ACTION_NAME)):
			wall_jump_direction = Vector2(-1.5, -1)

		else:
			return false

		return Input.is_action_just_pressed(PlayerConstants.JUMP_ACTION_NAME)

	return false


func start(player: CharacterBody2D):
	wall_jump_state = Wall_Jump_State.PRE_WALL_JUMP
	player_node = player



func get_to_next_state():
	if wall_jump_state == Wall_Jump_State.PRE_WALL_JUMP:
		# wall_jumping.start()
		wall_jump_state = Wall_Jump_State.WALL_JUMPING

	elif wall_jump_state == Wall_Jump_State.WALL_JUMPING:
		state_machine.state = state_machine.States.IDLE
		wall_jump_state = Wall_Jump_State.NONE


	elif wall_jump_state == Wall_Jump_State.NONE:  # ??
		wall_jump_state = Wall_Jump_State.PRE_WALL_JUMP


func physics_process(delta: float, player: CharacterBody2D):
	match (wall_jump_state):
		Wall_Jump_State.PRE_WALL_JUMP:
			pre_wall_jump.physics_process(delta, player)
			pass

		Wall_Jump_State.WALL_JUMPING:
			wall_jumping.physics_process(delta, player)
			pass

		Wall_Jump_State.NONE:  # isn't supposed to happen
			print("Wall Jump in NONE state, not supposed to happen")
			pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(_delta: float, _player: CharacterBody2D):
	pass





