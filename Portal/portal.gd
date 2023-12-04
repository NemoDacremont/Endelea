@tool
extends Area2D

@export var portal_color: Color = Color(0, 1, 0, 1):
	set(p_portal_color):
		portal_color = p_portal_color
		if Engine.is_editor_hint():
			print(p_portal_color)
			$PortalSprite.material.set_shader_parameter("portal_color", portal_color)
			print("parameter: portal_color: ", $PortalSprite.material.get("shader_parameter/portal_color"))
			# set("material/shader_parameter/portal_color", p_portal_color)
			# print(get("material/shader_parameter/portal_color"))


var portal: Sprite2D
var portal_texture: Texture = load("res://Portal/portal.tres")

func _ready():
	print("parameter: ", portal_color)
	$PortalSprite.material.set_shader_parameter("portal_color", portal_color)
	print("parameter: portal_color: ", $PortalSprite.material.get("shader_parameter/portal_color"))
