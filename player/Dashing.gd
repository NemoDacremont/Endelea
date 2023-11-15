extends Node


@onready var dash: Node = get_parent()
@onready var dash_direction: Vector2 = dash.dash_direction

static var dashing_time: float = 0



func physics_process(delta: float, player: CharacterBody2D):
	player.acceleration = Vector2.ZERO

	dash_direction = dash.dash_direction
	dashing_time += delta

	player.velocity = dash_direction * PlayerConstants.DASH_SPEED
	player.move_and_slide()

	print("Dashing: ", dashing_time, " / ", PlayerConstants.DASH_DURATION)

	if (dashing_time >= PlayerConstants.DASH_DURATION):
		dashing_time = 0
		player.velocity.y = player.velocity.y / 2
		dash.get_to_next_state()


func process(delta):
	pass


