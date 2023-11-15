extends Node

@onready var player: CharacterBody2D = find_parent("Player")
@onready var coyote_jump_timer: Timer = $CoyoteJumpTimer

static var was_on_floor: bool = false
static var available: bool = false


func force_coyote_availability(coyote_state: bool) -> void:
	available = coyote_state


func physics_process() -> void:
	if (player.is_on_floor()):
		was_on_floor = true

	elif (was_on_floor):
		was_on_floor = false
		available = true
		coyote_jump_timer.start(PlayerConstants.COYOTE_JUMP_DURATION)


func is_coyote_jump_available() -> bool:
	return available


func _on_coyote_jump_timer_timeout() -> void:
	available = false

