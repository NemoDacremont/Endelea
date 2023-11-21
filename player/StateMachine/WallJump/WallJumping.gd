extends Node


# Nodes
@onready var wall_jump: Node = get_parent()
@onready var player_node: CharacterBody2D = wall_jump.get_parent().get_parent()
@onready var wall_jump_timer: Timer = get_node("../WallJumpTimer")


# Copy pasted from idle
static var is_moving_right: bool = false
static var is_moving_left: bool = false


static var movement_direction: int = 1
static var run_force: Vector2 = PlayerConstants.ACCEL_X * Vector2.RIGHT
static var air_friction_force: Vector2 = Vector2.ZERO

static var default_gravity_force: Vector2 = PlayerConstants.GRAVITY * Vector2.DOWN
static var gravity_force: Vector2 = PlayerConstants.GRAVITY * Vector2.DOWN


func start():
	player_node.velocity = PlayerConstants.JUMP_VELOCITY * wall_jump.wall_jump_direction
	wall_jump_timer.start(PlayerConstants.WALL_JUMP_BLOCKING_DURATION)



func physics_process(delta: float, player: CharacterBody2D):
	player.acceleration = Vector2.ZERO  # Recalculate on every frames

	movement_direction = wall_jump.wall_jump_direction.x

	# Update forces
	run_force = movement_direction * PlayerConstants.ACCEL_X * Vector2.RIGHT
	air_friction_force.x = - PlayerConstants.AIR_FRICTION_X * player.velocity.x / 10

	# gravity is higher when falling
	gravity_force = default_gravity_force
	if (player.velocity.y > 0):
		gravity_force *= PlayerConstants.FALLING_GRAVITY_MULTIPLIER


	# Update accel
	player.acceleration = run_force + air_friction_force
	if (not player.is_on_floor()):
		player.acceleration += gravity_force


	# Integrate accel and cap falling speed
	player.velocity += player.acceleration * delta
	player.velocity.y = min(player.velocity.y, PlayerConstants.MAX_FALL_SPEED)


	# godot doing godot thigns
	player.move_and_slide()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(_delta: float, _player: CharacterBody2D):
	pass


func _on_wall_jump_timer_timeout():
	wall_jump.get_to_next_state()


