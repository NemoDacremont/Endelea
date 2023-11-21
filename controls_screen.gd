extends Control

signal exit_control_screen

const MIN_TIMER_DURATION: float = 1  # .5s before enabling quitting

var min_timer: Timer
var tween: Tween
var press_key: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	min_timer = $MinTimer
	press_key = find_child("PressKey")

	# Hide press_key, reveal it on min_timer end
	# press_key.set_visible_ratio(0.0)

	min_timer.start(MIN_TIMER_DURATION);


func _input(event):
	if (min_timer.is_stopped() && event is InputEventKey):
		emit_signal("exit_control_screen")
		get_tree().change_scene_to_file("res://main.tscn")


func _on_min_timer_timeout():
	tween = get_tree().create_tween()
	tween.tween_property(press_key, "visible_ratio", 1, .5)





