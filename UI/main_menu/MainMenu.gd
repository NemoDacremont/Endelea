extends Control

@onready var control_screen: Control = $CanvasLayer/ControlsScreen
@onready var canvas_layer : CanvasLayer = $CanvasLayer
@onready var fading: ColorRect = $CanvasLayer/Fading

@onready var fading_tween: Tween
@onready var fading_timer: Timer = $CanvasLayer/FadingTimer

func _ready():
	show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = false
	Global.init()

	# fading.show()
	# fading.color = Color(0.875, 0.973, 1, 1)
	# fading_tween = get_tree().create_tween()
	# fading_tween.tween_property(fading, "color:a", 0, 2)


func _on_play_pressed():
	canvas_layer.show()
	control_screen.show()
	control_screen.start()


func _on_quit_pressed():
	get_tree().quit()


func _on_controls_screen_exit_control_screen():
	# fading_tween = get_tree().create_tween()
	# fading_tween.tween_property(fading, "color:a", 1, 1)

	fading_timer.start(0.0);


func _on_fading_timer_timeout():
	SceneSwitcher.goto_scene("res://Levels/tutorial_level/tutorial_level.tscn")

