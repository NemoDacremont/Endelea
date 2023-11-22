extends Node

signal reset_dash


# Count the dashes used, one dash is available till you touch floor or wall
static var dash_counter: int = 0

static var dash_time: float = 0
static var dash_speed: float = 0

# On trigger, dash_direction is defined and usable in other nodes
var dash_direction: Vector2 = Vector2.UP


enum Dash_State {PRE_DASH, DASHING, NONE, DASH_STATES_COUNT}
static var dash_state: Dash_State = Dash_State.NONE

@onready var state_machine: Node = get_parent()
@onready var pre_dash: Node = $PreDash
@onready var dashing: Node = $Dashing
@onready var idle: Node = get_node("../Idle")  # shouldn't be used, but to be sure

@onready var player_node: CharacterBody2D = find_parent("Player")


func is_triggered() -> bool:
	if Input.is_action_just_pressed(PlayerConstants.DASH_ACTION_NAME):
		dash_direction = Vector2.ZERO  # Default direction

		# detect direction on x axis
		if Input.is_action_pressed(PlayerConstants.MOVE_LEFT_ACTION_NAME):
			dash_direction.x = -1
		elif Input.is_action_pressed(PlayerConstants.MOVE_RIGHT_ACTION_NAME):
			dash_direction.x = 1


		# detect direction on y axis
		if Input.is_action_pressed(PlayerConstants.LOOK_UP_ACTION_NAME):
			dash_direction.y = -1
		elif Input.is_action_pressed(PlayerConstants.LOOK_DOWN_ACTION_NAME):
			dash_direction.y = 1

		if (dash_direction == Vector2.ZERO):
			dash_direction = Vector2.UP



		dash_direction = dash_direction.normalized()

		return true

	return false


func can_start() -> bool:
	return dash_counter < PlayerConstants.MAX_DASH_COUNTER


func start():
	dash_state = Dash_State.PRE_DASH
	dash_counter += 1


func get_to_next_state():
	if dash_state == Dash_State.PRE_DASH:
		dash_state = Dash_State.DASHING

	elif dash_state == Dash_State.DASHING:
		state_machine.push_state(state_machine.States.IDLE)
		dash_state = Dash_State.NONE

	elif dash_state == Dash_State.NONE:  # ??
		dash_state = Dash_State.PRE_DASH



func capture_inputs():
	pass


func physics_process(delta: float, player: CharacterBody2D):
	capture_inputs()

	match (dash_state):
		Dash_State.PRE_DASH:
			pre_dash.physics_process(delta, player)

		Dash_State.DASHING:
			dashing.physics_process(delta, player)

		Dash_State.NONE:  # isn't supposed to happen
			pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float, _player: CharacterBody2D):
	match (dash_state):
		Dash_State.PRE_DASH:
			pre_dash.process(delta)

		Dash_State.DASHING:
			dashing.process(delta)

		Dash_State.NONE:  # isn't supposed to happen
			print("Dash is in NONE state, shouldn't be possible")


func background_process():
	if player_node.is_on_floor():
		emit_signal("reset_dash")


func _on_reset_dash():
	## Reset only when not currently dashing, so you can't double dash from the ground
	if (dash_state == Dash_State.NONE):
		dash_counter = 0




