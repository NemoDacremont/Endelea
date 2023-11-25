extends Node2D

func _on_body_shape_entered(_body_rid:RID, _body:Node2D, _body_shape_index:int, _local_shape_index:int):
	Global.number_of_coins += 1
	print(Global.number_of_coins)
	hide()


