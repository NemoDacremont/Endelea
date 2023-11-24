extends CharacterBody2D

signal pause
signal reset_position

var acceleration: Vector2 = Vector2.ZERO


@onready var dash: Node = find_child("Dash")


func start():
	velocity = Vector2.ZERO
	dash.force_reset_dash_counter()


func _process(_delta):
	if (Input.is_action_just_pressed("pause")):
		emit_signal("pause");





