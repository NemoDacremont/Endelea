extends Control

const FADING_DURATION: float = 1

@onready var pause_screen = $UI/Pause_Screen

var fading_tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	var fading = $UI/Control/Fading
	fading.color = Color(0.875, 0.973, 1, 1)
	fading_tween = get_tree().create_tween();
	fading.visible = true  # set to false in editor so can work on the scene

	fading_tween.tween_property(fading, "color", Color(0.875, 0.973, 1, 0), FADING_DURATION)



func _on_player_pause():
	pause_screen.visible = !pause_screen.visible

