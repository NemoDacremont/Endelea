extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const TAKEN_ANIMATION_NAME: String = "taken"
# const IDLE_ANIMATION_NAME: String = "idle"




func _on_body_shape_entered(_body_rid:RID, _body:Node2D, _body_shape_index:int, _local_shape_index:int):
	Global.number_of_coins += 1

	animation_player.play(TAKEN_ANIMATION_NAME)


