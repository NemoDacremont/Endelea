extends Node

const STATE_BUFFER_TIMER_DURATION: float = .1
#
#  Animations
#
const IDLE_ANIMATION_NAME: String = "Idle"
const WALK_ANIMATION_NAME: String = "Walk"
const RUN_ANIMATION_NAME: String = "Run"
const PRE_JUMP_ANIMATION_NAME: String = "land"
const JUMP_ANIMATION_NAME: String = "Jump"
const PRE_DASH_ANIMATION_NAME: String = "Pre_Dash"
const LAND_ANIMATION_NAME: String = "Land"
const WALL_SLIDE_ANIMATION_NAME: String = "Wall_Slide"

const PRE_DASH_ANIMATION_FRAME: int = 0

const JUMP_ANIMATION_EPSILON: float = abs(JUMP_VELOCITY / 3)


const COYOTE_JUMP_DURATION: float = 0.075
#
#  Dimensions
#

const HEIGHT = 64
const WIDTH = 64

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

const WALL_INTERACTION_NORM: float = GRAVITY / 2

# Jump
## PreJump
const PRE_JUMP_DURATION: float = .075  # in sec
const PRE_JUMP_VELOCITY_MULTIPLIER: float = 0.25

# A bit dirty way to handle things i think, im lazy
const PRE_JUMP_PART1_DURATION: float = PRE_JUMP_DURATION / 2
const PRE_JUMP_PART2_DURATION: float = PRE_JUMP_DURATION / 2



## Jumping
const MAX_HEIGHT_JUMP: float = 2 * HEIGHT
const JUMP_DURATION: float = .65  # 1 seconde


# Dash
## PreDash
const PRE_DASH_VELOCITY_MULTIPLIER: float = .1
const PRE_DASH_DURATION: float = .1


## Dashing
const DASH_LENGTH: float = 2 * WIDTH
const DASH_DURATION: float = .15
const DASH_SPEED: float = DASH_LENGTH / DASH_DURATION

const MAX_DASH_COUNTER: int = 1


# Wall Jump
## PreWallJump
const PRE_WALL_JUMP_DURATION: float = 0.05  # in sec
const PRE_WALL_JUMP_VELOCITY_MULTIPLIER: float = 0.25


const WALL_JUMP_BLOCKING_DURATION: float = .1  # s
# A bit dirty way to handle things i think, im lazy

# Idle
## Run

const MAX_SPEED_X: float = 3 * WIDTH 
const TIME_BEFORE_FULL_SPEED: float = 0.1
const AIR_FRICTION_X: float = 3 / TIME_BEFORE_FULL_SPEED

# Force applied to the player when moving on x axis
const ACCEL_X: float = MAX_SPEED_X * AIR_FRICTION_X



