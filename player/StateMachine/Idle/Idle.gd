extends Node

# Nodes
@onready var dash: Node = get_node("../Dash")
@onready var jump: Node = get_node("../Jump")
@onready var wall_jump: Node = get_node("../WallJump")
@onready var state_machine: Node = get_parent()

@onready var player_node: CharacterBody2D = find_parent("Player")
@onready var animation_node: AnimatedSprite2D = player_node.get_node("Sprite")

@onready var run_left_particles: GPUParticles2D = $RunLeftParticles
@onready var run_right_particles: GPUParticles2D = $RunRightParticles

# 
static var was_on_wall: bool = false


static var is_moving_right: bool = false
static var is_moving_left: bool = false


static var movement_direction: int = 1
static var run_force: Vector2 = PlayerConstants.ACCEL_X * Vector2.RIGHT
static var air_friction_force: Vector2 = Vector2.ZERO

static var default_gravity_force: Vector2 = PlayerConstants.GRAVITY * Vector2.DOWN
static var gravity_force: Vector2 = PlayerConstants.GRAVITY * Vector2.DOWN


static var animation: String = PlayerConstants.IDLE_ANIMATION_NAME
static var frame: int = -1;


static var wall_interaction_force: Vector2 = Vector2.UP
static var wall_interaction_fall_speed_multiplier: float = 1.0



func capture_inputs() -> void:
	is_moving_right = false
	is_moving_left = false

	if (Input.is_action_pressed(PlayerConstants.MOVE_RIGHT_ACTION_NAME)):
		is_moving_right = true

	elif (Input.is_action_pressed(PlayerConstants.MOVE_LEFT_ACTION_NAME)):
		is_moving_left = true



	if (dash.is_triggered()):
		state_machine.push_state(state_machine.States.DASH)

	elif (wall_jump.is_triggered()):
		state_machine.push_state(state_machine.States.WALL_JUMP)

	elif (jump.is_triggered()):
		state_machine.push_state(state_machine.States.JUMP)

	else:
		state_machine.push_state(state_machine.States.IDLE)



func can_start() -> bool:
	return true


func start() -> void:
	pass


func animation_process() -> void:
	frame = -1
	animation = PlayerConstants.IDLE_ANIMATION_NAME
	run_right_particles.emitting = false
	run_left_particles.emitting = false


	if (is_moving_right):
		animation_node.flip_h = false
		run_right_particles.emitting = true
		run_right_particles.position = player_node.position + Vector2(0, 28)

	elif (is_moving_left):
		animation_node.flip_h = true
		run_left_particles.emitting = true
		run_left_particles.position = player_node.position + Vector2(0, 28)

	if (is_moving_left or is_moving_right):
		animation = PlayerConstants.RUN_ANIMATION_NAME

	if (not player_node.is_on_floor() and not player_node.is_on_wall()):
		animation = PlayerConstants.JUMP_ANIMATION_NAME

		# Choose frame according to falling speed
		if (player_node.velocity.y < 0):
			frame = 0;

		elif (abs(player_node.velocity.y) < PlayerConstants.JUMP_ANIMATION_EPSILON):
			frame = 1;

		elif (player_node.velocity.y > 0):
			frame = 2;


	if (player_node.is_on_wall_only()):
		animation = PlayerConstants.WALL_SLIDE_ANIMATION_NAME


	animation_node.play(animation)

	if (frame != -1):
		animation_node.frame = frame

	
func physics_process(delta: float, player: CharacterBody2D) -> void:
	player.acceleration = Vector2.ZERO
	wall_interaction_fall_speed_multiplier = 1.0
	capture_inputs()

	if (player.is_on_floor()):
		PlayerConstants.AIR_FRICTION_X += (PlayerConstants.AIR_FRICTION_X_DEFAULT - PlayerConstants.AIR_FRICTION_X)

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
		gravity_force = PlayerConstants.FALLING_GRAVITY_MULTIPLIER * default_gravity_force



	if (not was_on_wall && player.is_on_wall()):
		was_on_wall = true

	elif (was_on_wall && not player.is_on_wall()):
		was_on_wall = false


	wall_interaction_force = Vector2.ZERO
	if (player.is_on_wall() and (is_moving_left or is_moving_right)):
		if (player.velocity.y > 0):
			wall_interaction_force = PlayerConstants.WALL_INTERACTION_NORM * (-sign(player.velocity.y)) * Vector2.DOWN
		wall_interaction_fall_speed_multiplier = .5


	# Update accel
	player.acceleration = run_force + air_friction_force + wall_interaction_force
	if (not player.is_on_floor()):
		player.acceleration += gravity_force


	# Integrate
	player.velocity += player.acceleration * delta

	player.velocity.y = min(player.velocity.y, PlayerConstants.MAX_FALL_SPEED * wall_interaction_fall_speed_multiplier)

	# godot doing godot thigns
	player.move_and_slide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(_delta: float, _player: CharacterBody2D) -> void:
	animation_process()


func background_process() -> void:
	pass


