extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const TAKEN_ANIMATION_NAME: String = "taken"
const IDLE_ANIMATION_NAME: String = "idle"
static var tween: Tween
var taken: bool = false


func _ready():
	animation_player.play(IDLE_ANIMATION_NAME)
	taken = false
	$GPUParticles2D.emitting = false
	$Sprite.speed_scale = 1
	# $Sprite.position = Vector2.ZERO


func fades_out(duration: float) -> void:
	# $PortalSprite.material.set_shader_parameter("portal_color", portal_color)
	tween = get_tree().create_tween()

	# tween.tween_property($Sprite, "material", 0.0, 1)
	tween.tween_method(change_alpha, 1.0, 0.0, duration).set_ease(Tween.EASE_IN)


func change_alpha(alpha: float) -> void:
	$Sprite.material.set_shader_parameter("alpha", alpha)
	
	



func _on_body_shape_entered(_body_rid:RID, _body:Node2D, _body_shape_index:int, _local_shape_index:int):
	if (not taken):
		Global.number_of_coins += 1
		taken = true

		animation_player.play(TAKEN_ANIMATION_NAME)


