extends Node

#
#  Var / Consts
#

@onready var player = get_parent()

enum States {
	IDLE,
	DASH,
	JUMP
}

const STATES_NAME = [
	"Idle",
	"Dash",
	"Jump"
]



#
#  Functions
#






# # Called when the node enters the scene tree for the first time.
# func _ready():
# 	pass # Replace with function body.
#
#
# # Called every frame. 'delta' is the elapsed time since the previous frame.
#enum  func _process(_delta):
# 	pass


