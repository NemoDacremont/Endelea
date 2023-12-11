extends ParallaxBackground

@onready var clouds: ParallaxLayer = $Clouds
const clouds_speed: float = 64
const movement_direction = Vector2.LEFT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scroll_base_offset += clouds_speed * delta * movement_direction

	pass
