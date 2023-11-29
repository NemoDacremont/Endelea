extends CanvasLayer

@onready var fading_node: ColorRect = $Control/FadingRect
const FADING_DURATION: float = 1.0  # in s

func _ready():
	print("REAYD!", fading_node)

func fades_in(color: Color = Global.DREAM_FADING_IN_COLOR, duration: float = FADING_DURATION) -> void:
	fading_node.color = color;

	var tween = get_tree().create_tween();
	tween.tween_property(fading_node, "color:a", 0, duration);


func fades_out(color: Color = Global.DREAM_FADING_OUT_COLOR, duration: float = FADING_DURATION) -> void:
	fading_node.color = color;

	var tween = get_tree().create_tween();
	tween.tween_property(fading_node, "color:a", 1, duration);
