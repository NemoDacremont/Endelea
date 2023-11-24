extends Control

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


func unpause():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	hide()


func _on_unpause_pressed():
	unpause()


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")

