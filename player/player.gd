extends CharacterBody2D

@onready var state_machine: Node = $StateMachine

var acceleration: Vector2 = Vector2.ZERO


func _physics_process(delta: float):
	state_machine.physics_process(delta)


func _process(delta):
	state_machine.process(delta)


