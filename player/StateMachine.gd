extends Node

#
#  Var / Consts
#

@onready var player = get_parent()

@onready var dash = $Dash
@onready var jump = $Jump
@onready var wall_jump= $WallJump
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
func capture_inputs():
	if (dash.is_triggered()):
		dash.start()
		state = States.DASH
	
	elif (jump.is_triggered(player)):
		jump.start(player)
		state = States.JUMP

	elif (wall_jump.is_triggered(player)):
		wall_jump.start(player)
		state = States.WALL_JUMP




func physics_process(delta):
	capture_inputs()

	match (state):
		States.DASH:
			dash.physics_process(delta, player)

		States.JUMP:
			jump.physics_process(delta, player)

		States.WALL_JUMP:
			wall_jump.physics_process(delta, player)
			pass

		States.IDLE:
			idle.physics_process(delta, player)


func process(delta):
	print(STATES_NAME[state])

	match (state):
		States.DASH:
			dash.process(delta, player)

		States.JUMP:
			jump.process(delta, player)

		States.WALL_JUMP:
			wall_jump.process(delta, player)
			pass

		States.IDLE:
			idle.process(delta, player)



