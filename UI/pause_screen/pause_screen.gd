extends Control

@onready var control_button: Button = $MarginContainer/VBoxContainer/Controls
@onready var control_screen: Control = $ControlsScreen

@onready var no_return_timer: Timer = $NoReturn
@onready var min_time_timer: Timer = $MinTime

var can_return: bool = true
var can_leave: bool = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


func start():
	process_mode = Node.PROCESS_MODE_ALWAYS
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	can_leave = false
	can_return = true

	min_time_timer.start(0.2)


func _process(_delta):
	if (can_leave && Input.is_action_just_pressed("pause")):
		unpause()


func unpause():
	if (can_leave):
		get_tree().paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		control_screen.hide()
		hide()


func _on_unpause_pressed():
	unpause()


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")


func _on_controls_screen_exit_control_screen():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	no_return_timer.start(0.2)
	can_return = false
	control_screen.hide()



func _on_controls_pressed():
	if (can_return):
		control_screen.start()
		control_screen.show()


func _on_no_return_timeout():
	can_return = true




func _on_min_time_timeout():
	can_leave = true

