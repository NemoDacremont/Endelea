extends Node


var current_scene = null
var fading_scene;

@onready var root: Window = get_tree().root
@onready var fading_node: CanvasLayer

var has_fading_ended: bool = true
var is_switching: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("READY!!!!! AND FROM SWITCHER!")
	current_scene = root.get_child(root.get_child_count() - 1)

	ResourceLoader.load_threaded_request(Global.FADING_PATH)
	fading_scene = ResourceLoader.load_threaded_get(Global.FADING_PATH);

	enter_new_scene()
	# fading_node.fades_in()
	# fading_node = current_scene.get_node("Fading")
	# fading_node.show()
	# fading_node.fades_in()


func enter_new_scene() -> void:
	print("ENTER NEW SCENE")
	fading_node = fading_scene.instantiate()
	current_scene.add_child(fading_node)
	fading_node = current_scene.get_node("Fading")

	fading_node.call_deferred("fades_in")



func goto_scene(path: String):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	if (!is_switching):
		is_switching = true
		print("goto ", path)
		fading_node.fades_out();
		has_fading_ended = false
		call_deferred("_deferred_goto_scene", path)

	else:
		print("IS ALREADY SWITCHING SCENE!!!")



func _deferred_goto_scene(path: String):
	# It is now safe to remove the current scene
	print("start defer")
	var fading_tween = fading_node.get_tween();

	var former_scene = current_scene

	# Load the new scene.
	ResourceLoader.load_threaded_request(path)
	var s = ResourceLoader.load_threaded_get(path)
	print(s)
	if (s == null or fading_tween == null):
		print("s=", s, " fading_tween=", fading_tween)
		goto_scene(Global.MAIN_SCENE)

	else:
		await fading_tween.finished
		print(fading_tween.finished)
		# Instance the new scene.
		current_scene = s.instantiate()

		# Add it to the active scene, as child of root.
		get_tree().root.add_child(current_scene)
		fading_node.free()

		# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
		get_tree().current_scene = current_scene
		print("Current_scene = ", current_scene)
		# fading_node.free()
		former_scene.free()
		enter_new_scene()
		print("Current_scene.children = ", current_scene.get_children())
		is_switching = false



