extends Node

#
#  Dimensions
#

const HEIGHT = 48
const WIDTH = 48

#
#  Actions
#

@export var MOVE_RIGHT_ACTION_NAME: String = "move_right"
@export var MOVE_LEFT_ACTION_NAME: String = "move_left"
@export var JUMP_ACTION_NAME: String = "jump"
@export var LOOK_UP_ACTION_NAME: String = "look_up"
@export var LOOK_DOWN_ACTION_NAME: String = "look_down"
@export var DASH_ACTION_NAME: String = "dash"


#
#  Physics
#

const FALLING_GRAVITY_MULTIPLIER: float = 1.5
const GRAVITY: float = 8 * MAX_HEIGHT_JUMP / (JUMP_DURATION**2)
const MAX_FALL_SPEED: float = 8 * HEIGHT  # 8 par seconde
const JUMP_VELOCITY: float = - 4 * MAX_HEIGHT_JUMP / JUMP_DURATION  # calculus so jump duration is .5s and max height is 3 * HEIGHT

# Jump
const MAX_HEIGHT_JUMP: float = 2 * HEIGHT
const JUMP_DURATION: float = .65  # 1 seconde


# Dash

# Run

const MAX_SPEED_X: float = 3 * WIDTH 
const TIME_BEFORE_FULL_SPEED: float = 0.1
const AIR_FRICTION_X: float = 3 / TIME_BEFORE_FULL_SPEED

# Force applied to the player when moving on x axis
const ACCEL_X: float = MAX_SPEED_X * AIR_FRICTION_X



