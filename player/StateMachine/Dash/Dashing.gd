extends Node


@onready var dash: Node = get_parent()
@onready var dash_direction: Vector2 = dash.dash_direction

static var dashing_time: float = 0

@onready var animationNode: AnimatedSprite2D = get_tree().get_current_scene().find_child("Sprite")
@onready var player_node: CharacterBody2D = find_parent("Player")


func animation_process():
	if (player_node.is_on_floor()):
		animationNode.play(PlayerConstants.RUN_ANIMATION_NAME)
	else:
		animationNode.play(PlayerConstants.RUN_ANIMATION_NAME)
		animationNode.frame = 0


func physics_process(delta: float, player: CharacterBody2D):
	player.acceleration = Vector2.ZERO

	dash_direction = dash.dash_direction
	dashing_time += delta

	player.velocity = dash_direction * PlayerConstants.DASH_SPEED
	player.move_and_slide()

	if (dashing_time >= PlayerConstants.DASH_DURATION):
		dashing_time = 0
		player.velocity.y = player.velocity.y / 2
		dash.get_to_next_state()


func process(_delta):
	animation_process()


