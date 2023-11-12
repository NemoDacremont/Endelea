extends Node


@onready var wall_jump: Node = get_parent()
@onready var player_node: CharacterBody2D = wall_jump.get_parent().get_parent()
@onready var wall_jump_timer: Timer = $WallJumpTimer

static var are_movements_blocked: bool = false

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



func start():
	player_node.velocity = PlayerConstants.JUMP_VELOCITY * wall_jump.wall_jump_direction
	are_movements_blocked = true



func physics_process(delta: float, player: CharacterBody2D):
	capture_inputs()
	print(wall_jump.wall_jump_direction)


	player.acceleration = Vector2.ZERO
	# Almost entirely copy paster from idle (just slowed)
	# Update run force direction
	movement_direction = 0

	if (is_moving_right):
		movement_direction = 1
	elif (is_moving_left):
		movement_direction = -1

	if (are_movements_blocked):
		movement_direction = 0


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
		wall_jump.get_to_next_state()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(_delta: float, _player: CharacterBody2D, _idle: Node):
	pass


func _on_wall_jump_timer_timeout():
	are_movements_blocked = false

