extends CharacterBody2D

#
# Inputs
#
## Add the possibility to use custom actions name for instances
## Enables creating 2 players for the same keyboard
@export var MOVE_RIGHT_ACTION_NAME: String = "move_right"
@export var MOVE_LEFT_ACTION_NAME: String = "move_left"
@export var JUMP_ACTION_NAME: String = "jump"

const HEIGHT = 48
const WIDTH = 48

## Input control variables
var is_moving_right: bool = false
var is_moving_left: bool = false

## direction = 1 if moving right, -1 if moving left
var direction: int = 1

#
# Physics
#
var acceleration: Vector2 = Vector2.ZERO

## Axe x
@export var MAX_SPEED_X: float = 4 * WIDTH  # 4 * WIDTH per second
@export var time_full_speed = 0.1
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

	if Input.is_action_pressed(MOVE_RIGHT_ACTION_NAME):
		is_moving_right = true
	if Input.is_action_pressed(MOVE_LEFT_ACTION_NAME):
		is_moving_left = true



#
# Procédures Animations
#
func animation_process():
	animation = IDLE_ANIMATION_NAME

	if (is_moving_left or is_moving_right):
		animation = WALK_ANIMATION_NAME

	animation_node.flip_h = velocity.x < 0

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



#
# Procédure physics
#
func _physics_process(delta: float):
	capture_inputs()

	# Add the gravity.
	if not is_on_floor():
		acceleration.y = gravity 


	# Handle Jump.
	if Input.is_action_just_pressed(JUMP_ACTION_NAME) and is_on_floor():
		velocity.y = JUMP_VELOCITY


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

	move_and_slide()



func _process(_delta):
	animation_process()




