extends Control

const FADING_DURATION: float = 1

@onready var pause_screen = $UI/Pause_Screen
@onready var level = $Level

@onready var start_player_position: Marker2D = $Level/FirstPlayerPosition
@onready var respawn_timer: Timer = $Level/RespawnTimer
@onready var player: CharacterBody2D = $Level/Player


@onready var end_timer: Timer = $Level/EndTimer

var portal: Resource;
var fading_tween: Tween


# Called when the node enters the scene tree for the first time.
func _ready():
	portal = load("res://Portal/portal2.tscn")
	start()

func start():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	var fading = $UI/Control/Fading
	fading.color = Color(0.341, 0, 0.098, 1)
	fading_tween = get_tree().create_tween();
	fading.visible = true  # set to false in editor so can work on the scene


	player.position = start_player_position.position
	player.start()
	fading_tween.tween_property(fading, "color", Color(0.341, 0, 0.098, 0.0), FADING_DURATION)




func _process(delta):
	Global.time += delta


func _on_player_pause():
	pause_screen.start()
	get_tree().paused = true
	pause_screen.show()



func _on_area_2d_body_shape_entered(_body_rid, _body, _body_shape_index, _local_shape_index):
	var fading = $UI/Control/Fading
	fading_tween = get_tree().create_tween();
	fading.visible = true  # set to false in editor so can work on the scene
	fading_tween.tween_property(fading, "color", Color(0.341, 0, 0.098, 1.0), 3 * FADING_DURATION / 4)

	respawn_timer.start(3 * FADING_DURATION / 4)


func _on_respawn_timer_timeout():
	start()


func _on_portal_body_entered(_body: Node2D) -> void:
	SceneSwitcher.goto_scene("res://UI/end_screen/end_screen.tscn")



