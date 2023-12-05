extends Control

@onready var time_node: Label = $VBoxContainer/VBoxContainer/Time
@onready var press_key_timer: Timer = $PressKeyTimer


@onready var press_key: Label = $VBoxContainer/VBoxContainer2/Restart

const PRESS_KEY_COLOR: Color = Color(0.875, 0.973, 1, 0.0);
var tween_press_key_alpha: Tween

var can_key_press: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	time_node.text = "Your time: " + str(round(Global.time)) + " seconds, coins: " + str(Global.number_of_coins)
	
	press_key.set("theme_override_colors/font_color/a", 0);

	press_key_timer.start(1.5)
	print("keypressstart")


func _process(_delta):
	if (can_key_press && Input.is_action_just_pressed("return")):
		can_key_press = false
		SceneSwitcher.goto_scene("res://UI/main_menu/main_menu.tscn")


func change_key_press_alpha(alpha: float) -> void:
	var c = PRESS_KEY_COLOR
	c.a = alpha
	press_key.set("theme_override_colors/font_color", c);


func _on_press_key_timer_timeout():
	tween_press_key_alpha = get_tree().create_tween()
	print("timeout")

	# Hide press_key, reveal it on min_timer end
	tween_press_key_alpha.tween_method(change_key_press_alpha, 0.0, 1.0, .5)
	can_key_press = true


