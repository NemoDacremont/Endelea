extends Camera2D


@onready var fog: ColorRect = $Fog;

func _physics_process(_delta):
	fog.position = position - Vector2(fog.size.x, fog.size.y) / 2

