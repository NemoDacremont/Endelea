extends Node


@onready var dash: Node = get_parent()
@onready var dash_direction: Vector2 = dash.dash_direction

static var dashing_time: float = 0

@onready var player_node: CharacterBody2D = find_parent("Player")
@onready var animationNode: AnimatedSprite2D = player_node.get_node("Sprite")

@onready var particles: GPUParticles2D = $DashParticles


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

	particles.position = player.position

	if (dashing_time >= PlayerConstants.DASH_DURATION):
		dashing_time = 0
		player.velocity.y = player.velocity.y / 2
		particles.emitting = false
		dash.get_to_next_state()



func start():
	particles.position = player_node.position
	particles.emitting = true


func process(_delta):
	animation_process()


