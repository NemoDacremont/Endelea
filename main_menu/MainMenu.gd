extends Control


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_play_pressed():
	get_tree().change_scene_to_file("res://controls_screen/controls_screen.tscn")


func _on_quit_pressed():
	get_tree().quit()



