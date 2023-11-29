extends Node


var current_scene = null
var fading_scene;

@onready var root: Window = get_tree().root
@onready var fading_node: CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_scene = root.get_child(root.get_child_count() - 1)

	# fading_node = current_scene.get_node("Fading")
	# fading_node.show()
	# fading_node.fades_in()

	fading_scene = ResourceLoader.load("res://UI/fading/fading.tscn");
	print(fading_scene)


func goto_scene(path: String):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:


	print("goto ", path)
	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path: String):
	# It is now safe to remove the current scene
	print("start defer")
	var former_scene = current_scene

	# var new_fading_scene = fading_scene.instantiate()
	# get_tree().root.add_child(new_fading_scene)
	# new_fading_scene.fades_out()

	# Load the new scene.
	var s = ResourceLoader.load_threaded_get(path)
	print(s)
	if (s != null):
		# Instance the new scene.
		current_scene = s.instantiate()


		# Add it to the active scene, as child of root.
		get_tree().root.add_child(current_scene)

		# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
		get_tree().current_scene = current_scene
		print("Current_scene = ", current_scene)
		former_scene.free()


