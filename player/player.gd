extends CharacterBody2D

#
# Inputs
#
## Add the possibility to use custom actions name for instances
## Enables creating 2 players for the same keyboard
@export var MOVE_RIGHT_ACTION_NAME: String = "move_right"
@export var MOVE_LEFT_ACTION_NAME: String = "move_left"
@export var JUMP_ACTION_NAME: String = "jump"

## Input control variables
var is_moving_right: bool = false
var is_moving_left: bool = false

## direction = 1 if moving right, -1 if moving left
var direction: int = 1

#
# Physics
#
var acceleration: Vector2 = Vector2.ZERO

@export var MAX_SPEED_X: float = 200.0  # à changer
@export var AIR_FRICTION_X: float = 10  # -> 3tau = 0.3s de régime transitoire

var ACCEL_X: float = MAX_SPEED_X * AIR_FRICTION_X

var F = 0

const SPEED: float = 300.0
const JUMP_VELOCITY: float = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func capture_inputs():
	is_moving_right = false
	is_moving_left = false

	if Input.is_action_pressed(MOVE_RIGHT_ACTION_NAME):
		is_moving_right = true
	if Input.is_action_pressed(MOVE_LEFT_ACTION_NAME):
		is_moving_left = true


func _physics_process(delta: float):
	capture_inputs()

	# Add the gravity.
	if not is_on_floor():
		acceleration.y += gravity * delta


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
	print(velocity.x)
	print(acceleration.x)




