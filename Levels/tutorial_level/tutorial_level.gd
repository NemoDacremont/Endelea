extends Control

const FADING_DURATION: float = 1

@onready var pause_screen = $UI/Pause_Screen
@onready var level = $Level

@onready var start_player_position: Marker2D = $Level/FirstPlayerPosition
@onready var respawn_timer: Timer = $Level/RespawnTimer
@onready var player: CharacterBody2D = $Level/Player

@onready var respawn_fading_node: CanvasLayer = $RespawnFading


func start():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	player.position = start_player_position.position
	player.start()


# Called when the node enters the scene tree for the first time.
func _ready():
	respawn_fading_node.show()
	respawn_fading_node.force_color(Color(0, 0, 0, 0))
	print(respawn_fading_node.get_color())

	start()


func _process(delta):
	Global.time += delta


func _on_player_pause():
	pause_screen.start()
	get_tree().paused = true
	pause_screen.show()


func _on_area_2d_body_shape_entered(_body_rid, _body, _body_shape_index, _local_shape_index):
	respawn_fading_node.fades_out()
	respawn_timer.start(Global.FADING_DURATION)


func _on_respawn_timer_timeout():
	start()
	respawn_fading_node.fades_in()


func _on_portal_body_shape_entered(_body_rid:RID, _body:Node2D, _body_shape_index:int, _local_shape_index:int):
	SceneSwitcher.goto_scene("res://level_1/level1.tscn")

