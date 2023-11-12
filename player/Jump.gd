extends Node

static var is_moving_right: bool = false
static var is_moving_left: bool = false

static var movement_direction: int = 1
static var run_force: Vector2 = PlayerConstants.ACCEL_X * Vector2.RIGHT
static var air_friction_force: Vector2 = Vector2.ZERO

static var default_gravity_force: Vector2 = PlayerConstants.GRAVITY * Vector2.DOWN
static var gravity_force: Vector2 = PlayerConstants.GRAVITY * Vector2.DOWN


enum Jump_State {PRE_JUMP, JUMPING, NONE, JUMP_STATES_COUNT}
static var jump_state: Jump_State = Jump_State.NONE

@onready var pre_jump: Node = $Pre_Jump
@onready var jumping: Node = $Jumping
@onready var idle: Node = $Idle  # shouldn't be used, but to be sure


func is_triggered(player: CharacterBody2D) -> bool:
	if (player.is_on_floor()):
		return Input.is_action_just_pressed(PlayerConstants.JUMP_ACTION_NAME)

	return false


func get_to_next_state():
	if jump_state == Jump_State.PRE_JUMP:
		jump_state = Jump_State.JUMPING

	elif jump_state == Jump_State.JUMPING:
		jump_state = Jump_State.PRE_JUMP

	elif jump_state == Jump_State.NONE:  # ??
		jump_state = Jump_State.PRE_JUMP


func capture_inputs():
	is_moving_right = false
	is_moving_left = false

	if (Input.is_action_pressed(PlayerConstants.MOVE_RIGHT_ACTION_NAME)):
		is_moving_right = true

	elif (Input.is_action_pressed(PlayerConstants.MOVE_LEFT_ACTION_NAME)):
		is_moving_left = true


func physics_process(delta: float, player: CharacterBody2D):
	capture_inputs()

	match (jump_state):
		Jump_State.PRE_JUMP:
			# pre_jump.physics_process(delta, player, idle)
			pass

		Jump_State.JUMPING:
			# jumping.physics_process(delta, player, idle)
			pass

		Jump_State.NONE:  # isn't supposed to happen
			idle.physics_process(delta, player)
			pass
>>>>>>> Stashed changes



# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(_delta: float, _player: CharacterBody2D):
	pass






>>>>>>> Stashed changes
