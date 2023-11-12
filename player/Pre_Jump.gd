extends Node

const PRE_JUMP_DURATION: float = 0.025  # in sec
const PRE_JUMP_VELOCITY_MULTIPLIER: float = 0.25

# A bit dirty way to handle things i think, im lazy
const PRE_JUMP_PART1_DURATION: float = PRE_JUMP_DURATION / 2
const PRE_JUMP_PART2_DURATION: float = PRE_JUMP_DURATION / 2

var pre_jump_part1_time: float = 0
var pre_jump_part2_time: float = 0

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



func physics_process(delta: float, player: CharacterBody2D):
	# Almost entirely copy paster from idle (just slowed)
	# Update run force direction
	movement_direction = 0

	if (is_moving_right):
		movement_direction = 1
	elif (is_moving_left):
		movement_direction = -1

	# Update forces
	run_force = movement_direction * PlayerConstants.ACCEL_X * Vector2.RIGHT
	air_friction_force = - PlayerConstants.AIR_FRICTION_X * player.velocity

	# gravity is higher if falling
	gravity_force = default_gravity_force
	if (player.velocity.y < 0):
		gravity_force *= PlayerConstants.FALLING_GRAVITY_MULTIPLIER


	# Update accel
	player.acceleration = run_force + air_friction_force
	if (not player.is_on_floor()):
		player.acceleration += gravity_force


	# Integrate
	player.velocity += player.acceleration * delta

	player.velocity.y = max(player.velocity.y, PlayerConstants.MAX_FALL_SPEED)

	# godot doing godot thigns
	player.move_and_slide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(_delta: float, _player: CharacterBody2D, _idle: Node):
	pass






