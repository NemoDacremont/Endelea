extends Control


const MIN_TIMER_DURATION: float = .5  # .5s before enabling quitting

@onready var min_timer: Timer = $MinTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	min_timer.start(MIN_TIMER_DURATION);


func _input(event):
	if (min_timer.is_stopped() && event is InputEventKey):
		print("Key pressed")
		pass


