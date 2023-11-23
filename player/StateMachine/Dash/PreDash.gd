extends Node

@onready var dash: Node = get_parent()

static var pre_dash_time: float = 0


static var tmp_velocity: Vector2 = Vector2.ZERO

#  Physics from Idle.gd
static var is_moving_right: bool = false
static var is_moving_left: bool = false


static var movement_direction: int = 1
static var run_force: Vector2 = PlayerConstants.ACCEL_X * Vector2.RIGHT
static var air_friction_force: Vector2 = Vector2.ZERO

static var default_gravity_force: Vector2 = PlayerConstants.GRAVITY * Vector2.DOWN
static var gravity_force: Vector2 = PlayerConstants.GRAVITY * Vector2.DOWN

@onready var animationNode: AnimatedSprite2D = get_tree().get_current_scene().find_child("Sprite")
static var dash_tween: Tween

func capture_inputs():
	is_moving_right = false
	is_moving_left = false

	if (Input.is_action_pressed(PlayerConstants.MOVE_RIGHT_ACTION_NAME)):
		is_moving_right = true

	elif (Input.is_action_pressed(PlayerConstants.MOVE_LEFT_ACTION_NAME)):
		is_moving_left = true




func physics_process(delta: float, player: CharacterBody2D):
	player.acceleration = Vector2.ZERO

	if (tmp_velocity != Vector2.ZERO):
		player.velocity = tmp_velocity
		

	# Idle with slow down
	capture_inputs()


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

	player.velocity.y = max(player.velocity.y, PlayerConstants.MAX_FALL_SPEED)

	tmp_velocity = player.velocity
	player.velocity *= PlayerConstants.PRE_DASH_VELOCITY_MULTIPLIER

	# godot doing godot thigns
	player.move_and_slide()


	# Predash things
	pre_dash_time += delta

	if (pre_dash_time >= PlayerConstants.PRE_DASH_DURATION):
		pre_dash_time = 0
		tmp_velocity = Vector2.ZERO
		dash.get_to_next_state()


func start():
	dash_tween = get_tree().create_tween()
	dash_tween.tween_property(animationNode, "scale", Vector2(.9, 1), PlayerConstants.PRE_DASH_DURATION).set_ease(Tween.EASE_IN)
	dash_tween.tween_property(animationNode, "scale", Vector2(.9, 1), PlayerConstants.PRE_DASH_DURATION / 2).set_ease(Tween.EASE_IN)
	dash_tween.tween_property(animationNode, "scale", Vector2(1, 1), PlayerConstants.PRE_DASH_DURATION).set_ease(Tween.EASE_OUT)


func process(_delta):
	pass




