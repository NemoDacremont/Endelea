extends Control

signal exit_control_screen

const MIN_TIMER_DURATION: float = 1  # .5s before enabling quitting
const BEFORE_TEXT_RATIO_DURATION: float = .5  # .5s before enabling quitting
const FADING_DURATION: float = 1  # .5s before enabling quitting


@onready var min_timer: Timer = $MinTimer
@onready var before_text_ratio: Timer = $BeforeTextRatio
var tween_ratio: Tween
var press_key: Label
var fading_timer: Timer

var fading: ColorRect

var tween_fading: Tween

var can_key_press: bool = false

# Called when the node enters the scene tree for the first time.
func start():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	press_key = find_child("PressKey")
	fading = find_child("Fading")
	fading_timer = find_child("FadingTimer")


	# Hide press_key, reveal it on min_timer end
	press_key.set_visible_ratio(0.0)
	can_key_press = false

	min_timer.start(MIN_TIMER_DURATION);


func _process(_delta):
	if (can_key_press && Input.is_action_just_pressed("return")):
		emit_signal("exit_control_screen")



func _on_min_timer_timeout():
	tween_ratio = get_tree().create_tween()
	press_key = find_child("PressKey")


	# Hide press_key, reveal it on min_timer end
	tween_ratio.tween_property(press_key, "visible_ratio", 1.0, .5)
	before_text_ratio.start(BEFORE_TEXT_RATIO_DURATION)



func _on_before_text_ratio_timeout():
	can_key_press = true


func _on_fading_timer_timeout():
	pass
