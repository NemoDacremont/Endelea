extends CharacterBody2D

#
# Inputs
#
## Add the possibility to use custom actions name for instances
## Enables creating 2 players for the same keyboard
@export var MOVE_RIGHT_ACTION_NAME: String = "move_right"
@export var MOVE_LEFT_ACTION_NAME: String = "move_left"
@export var JUMP_ACTION_NAME: String = "jump"

const COYOTE_JUMP_DURATION: float = 0.15
@onready var coyote_jump_timer: Timer = $CoyoteJumpTimer
var is_coyote_jump_available: bool = false
var has_just_left_floor: bool = false

const HEIGHT = 48
const WIDTH = 48

## Input control variables
var is_moving_right: bool = false
var is_moving_left: bool = false

#
# Super Actions
#
enum Super_Actions {JUMP_SUPER_ACTION, PRE_JUMP, IS_JUMPING, NO_SUPER_ACTION}
const super_action_names: Array[String] = ["Jump", "Pre jump", "Is jumping", "No supper action"]
const SUPER_ACTION_BUFFER_TIMER_DURATION: float = 0.2

const PRE_JUMP_DURATION: float = 0.025  # in sec
const PRE_JUMP_VELOCITY_MULTIPLIER: float = 0.5
const PRE_JUMP_PART1_DURATION: float = PRE_JUMP_DURATION / 2
const PRE_JUMP_PART2_DURATION: float = PRE_JUMP_DURATION / 2

var pre_jump_part1_time: float = 0
var pre_jump_part2_time: float = 0

var pre_jump_part: int = 0  # 0 indexed
var pre_jump_part_count: int = 2

var is_jump_available: bool = true

var next_action: Super_Actions = Super_Actions.NO_SUPER_ACTION
var super_action_buffer: Super_Actions = Super_Actions.NO_SUPER_ACTION

@onready var super_action_buffer_timer: Timer = $SuperActionBufferTimer


#
# Physics
#
var tmp_velocity: Vector2 = Vector2.ZERO
var acceleration: Vector2 = Vector2.ZERO

## direction = 1 if moving right, -1 if moving left
var direction: int = 1


## Axe x
@export var MAX_SPEED_X: float = 3 * WIDTH  # 4 * WIDTH per second
@export var time_full_speed: float = 0.1
var AIR_FRICTION_X: float = 3 / time_full_speed

var ACCEL_X: float = MAX_SPEED_X * AIR_FRICTION_X

## Axe y
const MAX_HEIGHT_JUMP: float = 2 * HEIGHT
const JUMP_DURATION: float = .65  # 1 seconde

const gravity: float = 8 * MAX_HEIGHT_JUMP / (JUMP_DURATION**2)
const JUMP_VELOCITY: float = - 4 * MAX_HEIGHT_JUMP / JUMP_DURATION  # calculus so jump duration is .5s and max height is 3 * HEIGHT


#
# Animations
#
const IDLE_ANIMATION_NAME: String = "Idle"
const WALK_ANIMATION_NAME: String = "Walk"
const JUMP_ANIMATION_NAME: String = "Jump"
const LAND_ANIMATION_NAME: String = "Land"

const JUMP_ANIMATION_EPSILON: float = abs(JUMP_VELOCITY / 3)


@onready var animation_node: AnimatedSprite2D = $Sprite
var animation: String = IDLE_ANIMATION_NAME
var animationFrame: int = 0


#
#  Procédure UX
#
func capture_inputs():
	is_moving_right = false
	is_moving_left = false

	if not has_just_left_floor && (not is_on_floor() and not is_on_wall()):
		has_just_left_floor = true
		is_coyote_jump_available = true
		coyote_jump_timer.start(COYOTE_JUMP_DURATION)


	if has_just_left_floor && (is_on_floor() or is_on_wall()):
		has_just_left_floor = false


	if Input.is_action_pressed(MOVE_RIGHT_ACTION_NAME):
		is_moving_right = true
	if Input.is_action_pressed(MOVE_LEFT_ACTION_NAME):
		is_moving_left = true

	super_action_capture_inputs()



#
# Procédures Animations
#
func animation_process(delta):

	animation = IDLE_ANIMATION_NAME

	if (is_moving_left or is_moving_right):
		animation = WALK_ANIMATION_NAME

	if (is_moving_right):
		animation_node.flip_h = false
	elif (is_moving_left):
		animation_node.flip_h = true

	if (not is_on_floor() && not is_on_wall()):
		animation = JUMP_ANIMATION_NAME

		if (velocity.y < 0):
			animationFrame = 0
		elif (abs(velocity.y) <= JUMP_ANIMATION_EPSILON):
			animationFrame = 1
		elif (velocity.y > 0):
			animationFrame = 2

		animation_node.frame = animationFrame

	animation_node.play(animation)

	super_action_animations_process(delta)


#
# Super Actions Handling
#

func get_next_action():
	next_action = super_action_buffer
	super_action_buffer = Super_Actions.NO_SUPER_ACTION


func super_action_capture_inputs():
	if (Input.is_action_just_pressed(JUMP_ACTION_NAME)):
		if (is_on_floor() or is_coyote_jump_available):
			print("Pre jump input")
			if (next_action == Super_Actions.NO_SUPER_ACTION):
				print("Pre jump next action")
				next_action = Super_Actions.PRE_JUMP
			else:
				print("Pre jump buffered")
				super_action_buffer = Super_Actions.PRE_JUMP
				super_action_buffer_timer.start(SUPER_ACTION_BUFFER_TIMER_DURATION)

		else:
			get_next_action()


func super_action_animations_process(delta):
	if (next_action == Super_Actions.PRE_JUMP):
		match (pre_jump_part):
			0:
				print("Pre jump part 1")
				animation_node.frame = 1
				animation_node.play(LAND_ANIMATION_NAME)
				pre_jump_part1_time += delta

				if (pre_jump_part1_time >= PRE_JUMP_PART1_DURATION):
					pre_jump_part = (pre_jump_part + 1) % pre_jump_part_count
					pre_jump_part1_time = 0


			1:
				print("Pre jump part 2")
				animation_node.frame = 0
				animation_node.play(LAND_ANIMATION_NAME)
				pre_jump_part2_time += delta

				if (pre_jump_part2_time >= PRE_JUMP_PART2_DURATION):
					pre_jump_part = (pre_jump_part + 1) % pre_jump_part_count
					pre_jump_part1_time = 0

					next_action = Super_Actions.JUMP_SUPER_ACTION

	if (next_action == Super_Actions.JUMP_SUPER_ACTION or next_action == Super_Actions.IS_JUMPING):
		pass  # Leave the default animation (falling etc...) coded in animation_process



func super_action_physics_process(_delta: float):
	match (next_action):
		Super_Actions.PRE_JUMP:
			tmp_velocity = velocity
			velocity = PRE_JUMP_VELOCITY_MULTIPLIER * tmp_velocity



		Super_Actions.JUMP_SUPER_ACTION:
			print("Super Action: ", super_action_names[Super_Actions.JUMP_SUPER_ACTION])
			velocity.y = JUMP_VELOCITY
			next_action = Super_Actions.IS_JUMPING

		Super_Actions.IS_JUMPING:
			if (is_on_floor()):
				get_next_action()



#
# Procédure physics
#
func _physics_process(delta: float):
	capture_inputs()

	if (tmp_velocity != Vector2.ZERO):
		velocity = tmp_velocity
		tmp_velocity = Vector2.ZERO

	# Add the gravity.
	if not is_on_floor():
		acceleration.y = gravity 


	if is_moving_right:
		direction = 1
	elif is_moving_left:
		direction = -1


	if is_moving_left or is_moving_right:
		acceleration.x = direction * ACCEL_X - AIR_FRICTION_X * velocity.x
	else:
		acceleration.x = - AIR_FRICTION_X * velocity.x
		

	# integrate acceleration
	velocity += delta * acceleration

	super_action_physics_process(delta)

	move_and_slide()



func _process(delta):
	animation_process(delta)


func _on_coyote_jump_timer_timeout():
	is_coyote_jump_available = false


func _on_super_action_buffer_timer_timeout():
	super_action_buffer = Super_Actions.NO_SUPER_ACTION


