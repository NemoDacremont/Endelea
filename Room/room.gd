extends Node2D

@export var platform_scene: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	var N = 10
	for i in range(N):
		var platform = platform_scene.instantiate()
		var platform_spawn_location: PathFollow2D = get_node('Path2D/PlatformSpawnLocation')
		platform_spawn_location.progress_ratio = (i+1 + randf() - 0.5)/N+1
		print(platform_spawn_location.progress_ratio)

		platform.position = platform_spawn_location.position
		add_child(platform)

