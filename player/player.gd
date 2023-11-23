extends CharacterBody2D

signal pause

var acceleration: Vector2 = Vector2.ZERO


func _process(_delta):
	if (Input.is_action_just_pressed("pause")):
		emit_signal("pause");


