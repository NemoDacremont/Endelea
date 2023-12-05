extends Control

@onready var control_screen: Control = $CanvasLayer/ControlsScreen
@onready var canvas_layer : CanvasLayer = $CanvasLayer


func _ready():
	show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = false
	Global.init()


func _on_play_pressed():
	# canvas_layer.show()
	control_screen.show()
	control_screen.start()

func _on_settings_pressed():
	SceneSwitcher.goto_scene("res://UI/settings/settings.tscn")


func _on_quit_pressed():
	get_tree().quit()


func _on_controls_screen_exit_control_screen():
	SceneSwitcher.goto_scene("res://Levels/tutorial_level/tutorial_level.tscn")

