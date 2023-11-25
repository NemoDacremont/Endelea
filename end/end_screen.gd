extends Control

@onready var time_node: Label = $VBoxContainer/VBoxContainer/Time
@onready var restart_node: Label = $VBoxContainer/VBoxContainer2/Restart

@onready var restart_timer: Timer = $RestartTimer

@onready var fading: ColorRect = $Fading
@onready var fading_tween : Tween = get_tree().create_tween();
@onready var press_key_timer: Timer = $PressKeyTimer

var can_key_press: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	fading_tween = get_tree().create_tween();
	fading.color = Color(0.878, 0.969, 1, 1);
	fading.visible = true  # set to false in editor so can work on the scene
	fading_tween.tween_property(fading, "color", Color(0.878, 0.969, 1, 0.0), 1)

	time_node.text = "Your time: " + str(round(Global.time)) + " seconds, coins: " + str(Global.number_of_coins)
	
	restart_node.visible_ratio = 0
	fading_tween.tween_property(restart_node, "visible_ratio", 1, 1).set_ease(Tween.EASE_OUT)

	press_key_timer.start(2)

func _process(_delta):
	if (can_key_press && Input.is_action_just_pressed("return")):
		fading_tween = get_tree().create_tween();
		fading_tween.tween_property(fading, "color", Color(0.878, 0.969, 1, 1.0), 1)
		restart_timer.start(1)
		can_key_press = false


func _on_restart_timer_timeout():
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")


func _on_press_key_timer_timeout():
	can_key_press = true


