extends CanvasLayer

signal fading_ended

const FADES_IN_ANIMATION_NAME: String = "fades_in"
const FADES_OUT_ANIMATION_NAME: String = "fades_out"

@onready var fading_node: ColorRect = $Fading/FadingRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	layer = 9999


func get_color() -> Color:
	return fading_node.color


func force_color(color: Color) -> void:
	fading_node.color = color;


func fades_in(color: Color = Global.DREAM_FADING_IN_COLOR, duration: float = Global.FADING_DURATION) -> void:
	fading_node.color = color;
	animation_player.play(FADES_IN_ANIMATION_NAME, -1, 1 / duration)


func fades_out(color: Color = Global.DREAM_FADING_OUT_COLOR, duration: float = Global.FADING_DURATION) -> void:
	fading_node.color = color;
	animation_player.play(FADES_OUT_ANIMATION_NAME, -1, 1 / duration)


func _on_animation_player_animation_finished(_anim_name:StringName):
	emit_signal("fading_ended")

