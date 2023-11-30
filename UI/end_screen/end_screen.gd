extends Control

@onready var time_node: Label = $VBoxContainer/VBoxContainer/Time
@onready var restart_node: Label = $VBoxContainer/VBoxContainer2/Restart

@onready var restart_timer: Timer = $RestartTimer

@onready var press_key_timer: Timer = $PressKeyTimer

var can_key_press: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():

	time_node.text = "Your time: " + str(round(Global.time)) + " seconds, coins: " + str(Global.number_of_coins)
	
	restart_node.visible_ratio = 0

	press_key_timer.start(2)

func _process(_delta):
	if (can_key_press && Input.is_action_just_pressed("return")):
		restart_timer.start(1)
		can_key_press = false


func _on_restart_timer_timeout():
	SceneSwitcher.goto_scene("res://UI/main_menu/main_menu.tscn")


func _on_press_key_timer_timeout():
	can_key_press = true


