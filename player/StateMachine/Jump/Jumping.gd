extends Node


@onready var jump: Node = get_parent()
@onready var player_node: CharacterBody2D = jump.get_parent().get_parent()


func start():  # Just create impulsion
	player_node.velocity.y = PlayerConstants.JUMP_VELOCITY
	jump.get_to_next_state()


func physics_process(_delta: float, _player: CharacterBody2D):
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process():
	pass






