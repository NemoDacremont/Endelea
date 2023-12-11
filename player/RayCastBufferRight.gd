extends RayCast2D

@onready var player: CharacterBody2D = find_parent("Player")

func _physics_process(_delta):
	position = player.position
