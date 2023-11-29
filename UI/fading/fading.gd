extends CanvasLayer

signal fading_ended

@onready var fading_node: ColorRect = $Fading/FadingRect
@onready var tween: Tween = get_tree().create_tween();

func _ready() -> void:
	layer = 9999


func fades_in(color: Color = Global.DREAM_FADING_IN_COLOR, duration: float = Global.FADING_DURATION) -> void:
	print("FADES IN")
	fading_node.color = color;

	tween = get_tree().create_tween();
	tween.tween_property(fading_node, "color:a", 0, duration);


func force_color(color: Color) -> void:
	fading_node.color = color;
	print("NEW COLOR: ", color, ", ", fading_node.color)


func get_color() -> Color:
	return fading_node.color


func fades_out(color: Color = Global.DREAM_FADING_OUT_COLOR, duration: float = Global.FADING_DURATION) -> void:
	print("FADES OUT")
	fading_node.color = color;

	tween = get_tree().create_tween();
	tween.tween_property(fading_node, "color:a", 1, duration);


func get_tween() -> Tween:
	return tween;



