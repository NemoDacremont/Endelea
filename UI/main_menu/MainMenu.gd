extends Control

@onready var control_screen: Control = $CanvasLayer/ControlsScreen
@onready var canvas_layer : CanvasLayer = $CanvasLayer
@onready var fading: ColorRect = $CanvasLayer/Fading

@onready var fading_tween: Tween
@onready var fading_timer: Timer = $CanvasLayer/FadingTimer

@onready var enter_timer: Timer = $enter

func _ready():
	show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# fading.color = Color(0.875, 0.973, 1, 0)
	# canvas_layer.hide()
	get_tree().paused = false
	Global.init()

	fading.show()
	fading.color = Color(0.875, 0.973, 1, 2)
	fading_tween = get_tree().create_tween()
	fading_tween.tween_property(fading, "color", Color(0.875, 0.973, 1, 0), 2).set_ease(Tween.EASE_IN)

	enter_timer.start(2)

	# get_tree().change_scene_to_file("res://tutorial_level/tutorial_level.tscn")

func _on_play_pressed():
	canvas_layer.show()
	control_screen.show()
	control_screen.start()


func _on_quit_pressed():
	get_tree().quit()


func _on_controls_screen_exit_control_screen():
	fading_tween = get_tree().create_tween()
	fading_tween.tween_property(fading, "color", Color(0.875, 0.973, 1, 1), 1)

	fading_timer.start(1.0);


func _on_fading_timer_timeout():
	get_tree().change_scene_to_file("res://tutorial_level/tutorial_level.tscn")




func _on_enter_timeout():
	canvas_layer.hide()

