extends Node

@onready var wall_jump = get_parent()

static var pre_jump_time: float = 0

var pre_jump_part: int = 0  # 0 indexed
var pre_jump_part_count: int = 2


# Copy pasted from idle
static var is_moving_right: bool = false
static var is_moving_left: bool = false


static var movement_direction: int = 1
static var run_force: Vector2 = PlayerConstants.ACCEL_X * Vector2.RIGHT
static var air_friction_force: Vector2 = Vector2.ZERO

static var default_gravity_force: Vector2 = PlayerConstants.GRAVITY * Vector2.DOWN
static var gravity_force: Vector2 = PlayerConstants.GRAVITY * Vector2.DOWN

static var tmp_velocity: Vector2 = Vector2.ZERO



func physics_process(delta: float, player: CharacterBody2D):
	player.acceleration = Vector2.ZERO
	
	if tmp_velocity != Vector2.ZERO:
		player.velocity = tmp_velocity


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

	tmp_velocity = player.velocity
	player.velocity *= PlayerConstants.PRE_WALL_JUMP_VELOCITY_MULTIPLIER

	# godot doing godot thigns
	player.move_and_slide()

	pre_jump_time += delta
	if (pre_jump_time >= PlayerConstants.PRE_WALL_JUMP_DURATION):
		pre_jump_time = 0
		wall_jump.get_to_next_state()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(_delta: float, _player: CharacterBody2D):
	pass






