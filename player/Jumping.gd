extends Node


@onready var jump: Node = get_parent()
@onready var player_node: CharacterBody2D = jump.get_parent().get_parent()

@onready var state_machine: Node = find_parent("StateMachine")

# Anmations
@onready var animation_node: AnimatedSprite2D = get_node("../../../Sprite")
static var animation: String = PlayerConstants.IDLE_ANIMATION_NAME
static var frame: int = -1;


# Copy pasted from idle
static var is_moving_right: bool = false
static var is_moving_left: bool = false


static var movement_direction: int = 1
static var run_force: Vector2 = PlayerConstants.ACCEL_X * Vector2.RIGHT
static var air_friction_force: Vector2 = Vector2.ZERO

static var default_gravity_force: Vector2 = PlayerConstants.GRAVITY * Vector2.DOWN
static var gravity_force: Vector2 = PlayerConstants.GRAVITY * Vector2.DOWN


func capture_inputs():
	is_moving_right = false
	is_moving_left = false

	if (Input.is_action_pressed(PlayerConstants.MOVE_RIGHT_ACTION_NAME)):
		is_moving_right = true

	elif (Input.is_action_pressed(PlayerConstants.MOVE_LEFT_ACTION_NAME)):
		is_moving_left = true

	elif (jump.is_triggered()):
		state_machine.push_state(state_machine.States.JUMP)


func animation_process():
	animation = PlayerConstants.JUMP_ANIMATION_NAME

	if (is_moving_right):
		animation_node.flip_h = false
	elif (is_moving_left):
		animation_node.flip_h = true

	# Choose frame according to falling speed
	if (player_node.velocity.y < 0):
		frame = 0;

	elif (abs(player_node.velocity.y) < PlayerConstants.JUMP_ANIMATION_EPSILON):
		frame = 1;

	elif (player_node.velocity.y > 0):
		frame = 2;

	animation_node.play(animation)
	animation_node.frame = frame



func start():
	player_node.velocity.y = PlayerConstants.JUMP_VELOCITY



func physics_process(delta: float, player: CharacterBody2D):
	capture_inputs()


	player.acceleration = Vector2.ZERO
	# Almost entirely copy paster from idle (just slowed)
	# Update run force direction
	movement_direction = 0

	if (is_moving_right):
		movement_direction = 1
	elif (is_moving_left):
		movement_direction = -1

	# Update forces
	run_force = movement_direction * PlayerConstants.ACCEL_X * Vector2.RIGHT
	air_friction_force.x = - PlayerConstants.AIR_FRICTION_X * player.velocity.x

	# gravity is higher if falling
	gravity_force = default_gravity_force
	if (player.velocity.y > 0):
		gravity_force *= PlayerConstants.FALLING_GRAVITY_MULTIPLIER


	# Update accel
	player.acceleration = run_force + air_friction_force
	if (not player.is_on_floor()):
		player.acceleration += gravity_force



	# Integrate
	player.velocity += player.acceleration * delta
	player.velocity.y = min(player.velocity.y, PlayerConstants.MAX_FALL_SPEED)


	# godot doing godot thigns
	player.move_and_slide()

	if (player.is_on_floor() or player.is_on_wall()):
		jump.get_to_next_state()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func process():
	animation_process()






