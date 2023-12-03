extends Control

signal exit_control_screen

const MIN_TIMER_DURATION: float = 1  # .5s before enabling quitting
const BEFORE_TEXT_RATIO_DURATION: float = .5  # .5s before enabling quitting
const FADING_DURATION: float = 1  # .5s before enabling quitting

const PRESS_KEY_COLOR: Color = Color(0.875, 0.973, 1, 0.0);


@onready var min_timer: Timer = $MinTimer
var press_key: Label
var tween_press_key_alpha: Tween
var fading_timer: Timer

var press_key_settings: LabelSettings

var can_key_press: bool = false


# Called when the node enters the scene tree for the first time.
func start():
	# Hides the mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	press_key = $MarginContainer/Rows/PressKey

	# Forces the color of press_key, will be moved to animation_player
	press_key.set("theme_override_colors/font_color", PRESS_KEY_COLOR);
	can_key_press = false

	min_timer.start(MIN_TIMER_DURATION);



func _process(_delta):
	if (can_key_press && Input.is_action_just_pressed("return")):
		emit_signal("exit_control_screen")


func change_key_press_alpha(alpha: float) -> void:
	var c = PRESS_KEY_COLOR
	c.a = alpha
	press_key.set("theme_override_colors/font_color", c);


func _on_min_timer_timeout():
	tween_press_key_alpha= get_tree().create_tween()

	# Hide press_key, reveal it on min_timer end
	tween_press_key_alpha.tween_method(change_key_press_alpha, 0.0, 1.0, .5)
	can_key_press = true

