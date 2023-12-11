extends Node


enum Wall_Jump_State {PRE_WALL_JUMP, WALL_JUMPING, NONE, WALL_JUMP_STATES_COUNT}
static var wall_jump_state: Wall_Jump_State = Wall_Jump_State.NONE

@onready var pre_wall_jump: Node = $PreWallJump
@onready var wall_jumping: Node = $WallJumping
@onready var state_machine: Node = get_parent()

@onready var player_node: CharacterBody2D = find_parent("Player")
@onready var dash: Node = get_node("../Dash")

@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight


@onready var ray_cast_buffer_left: RayCast2D = $RayCastBufferLeft
@onready var ray_cast_buffer_right: RayCast2D = $RayCastBufferRight
@onready var ray_cast_buffer_bottom: RayCast2D = $RayCastBufferBottom

@onready var buffer_timer: Timer = $BufferTimer

var wall_jump_direction: Vector2 = Vector2.UP


func is_triggered() -> bool:
	if (player_node.is_on_wall_only()):
		# Wall jump to the rightZ
		# print("TEST_RAYCAT ", ray_cast_left.is_colliding(), " ", ray_cast_left.collide_with_areas)
		if (ray_cast_left.is_colliding()):
			wall_jump_direction = Vector2(-1, 2)

		# Wall jump to the left
		elif (ray_cast_right.is_colliding()):
			wall_jump_direction = Vector2(1, 2)

		else:
			return false

		wall_jump_direction = wall_jump_direction.normalized()
		return Input.is_action_just_pressed(PlayerConstants.JUMP_ACTION_NAME)

	return false


func can_start():
	return player_node.is_on_wall_only()


func start():
	wall_jump_state = Wall_Jump_State.PRE_WALL_JUMP



func get_to_next_state():
	if wall_jump_state == Wall_Jump_State.PRE_WALL_JUMP:
		wall_jump_state = Wall_Jump_State.WALL_JUMPING
		wall_jumping.start()

	elif wall_jump_state == Wall_Jump_State.WALL_JUMPING:
		state_machine.push_state(state_machine.States.IDLE)
		wall_jump_state = Wall_Jump_State.NONE


	elif wall_jump_state == Wall_Jump_State.NONE:  # ??
		wall_jump_state = Wall_Jump_State.PRE_WALL_JUMP


func physics_process(delta: float, player: CharacterBody2D):
	match (wall_jump_state):
		Wall_Jump_State.PRE_WALL_JUMP:
			pre_wall_jump.physics_process(delta, player)

		Wall_Jump_State.WALL_JUMPING:
			wall_jumping.physics_process(delta, player)

		Wall_Jump_State.NONE:  # isn't supposed to happen
			pass


	if (dash.is_triggered()):
		state_machine.push_state(state_machine.States.DASH)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float, player: CharacterBody2D):
	match (wall_jump_state):
		Wall_Jump_State.PRE_WALL_JUMP:
			pre_wall_jump.process(delta, player)

		Wall_Jump_State.WALL_JUMPING:
			wall_jumping.process(delta, player)

		Wall_Jump_State.NONE:  # isn't supposed to happen
			print("Wall Jump in NONE state, not supposed to happen")
			pass


func background_process():
	if (state_machine.get_buffer_state() == state_machine.States.JUMP):
		if (not ray_cast_buffer_bottom.is_colliding()):
			if (ray_cast_left.is_colliding() or ray_cast_right.is_colliding()):
				state_machine.buffer_state(state_machine.States.WALL_JUMP)
				buffer_timer.start()



func stop_buffer_timer():
	buffer_timer.stop()



func _on_buffer_timer_timeout():
	state_machine.clear_buffer(state_machine.States.WALL_JUMP)

