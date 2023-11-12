extends Node

#
#  Var / Consts
#

@onready var player = get_parent()

@onready var dash = $Dash
@onready var jump = $Jump
@onready var wall_jump= $Wall_Jump
@onready var idle = $Idle

enum States {
	DASH,
	JUMP,
	WALL_JUMP,
	IDLE,
}

const STATES_NAME = [
	"Dash",
	"Jump",
	"Wall jump",
	"Idle"
]


var state: States = States.IDLE

#
#  Functions
#

func physics_process(delta):
	match (state):
		States.DASH:
			pass

		States.JUMP:
			jump.physics_process()

		States.WALL_JUMP:
			pass

		States.IDLE:
			idle.physics_process(delta, player)


func process(delta):
	match (state):
		States.DASH:
			pass

		States.JUMP:
			jump.process()

		States.WALL_JUMP:
			pass

		States.IDLE:
			idle.process(delta, player)
