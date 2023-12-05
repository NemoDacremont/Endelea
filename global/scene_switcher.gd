extends Node

var current_scene = null
var former_scene = null
var fading_scene;

var root: Window
var main_scene: Control
var fading_node: CanvasLayer
var scene_placeholder: Node

var has_fading_ended: bool = true
var is_switching: bool = false

var new_scene: Resource
var loading_scene_path: String = ""

var use_sub_threads: bool = true

var ressource_loader_thread: Thread = Thread.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	root = get_tree().root
	main_scene = root.get_child(root.get_child_count() - 1)
	print("main scene: ", main_scene)

	fading_node = main_scene.get_node("Fading")
	scene_placeholder = main_scene.get_node("ScenePlaceholder")
	current_scene = scene_placeholder.get_child(scene_placeholder.get_child_count() - 1)

	ResourceLoader.load_threaded_request("res://Portal/portal.tscn")

	print("READY!!!!! AND FROM SWITCHER!")
	print("current scene: ", current_scene)
	fading_node.show()
	set_process(false)  # Stop process no loading at start

	enter_new_scene()

func _exit_tree():
	ressource_loader_thread.wait_to_finish()


func enter_new_scene() -> void:
	print("ENTER NEW SCENE")

	fading_node.call_deferred("fades_in")
	get_tree().paused = false  # Force resume


func _process(_delta):
	var load_status = ResourceLoader.load_threaded_get_status(loading_scene_path)

	match load_status:
		ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE: #? THREAD_LOAD_INVALID_RESOURCE, THREAD_LOAD_FAILED
			print("RATIO, code mieux")

		ResourceLoader.THREAD_LOAD_LOADED:
			new_scene = ResourceLoader.load_threaded_get(loading_scene_path)
			change_scene(new_scene)
			set_process(false)


func change_scene(s: Resource):
	print("new_scene = ", s)
	ressource_loader_thread.wait_to_finish()

	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	scene_placeholder.call_deferred("add_child", current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	print("Current_scene = ", current_scene)
	former_scene.free()

	enter_new_scene()
	print("Current_scene.children = ", current_scene.get_children())
	is_switching = false
	new_scene = null



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

		# Starts fading
		fading_node.fades_out();

		has_fading_ended = false
		loading_scene_path = path

		var b = _deferred_goto_scene.bind(path)

		await Signal(fading_node, "fading_ended")
		ressource_loader_thread.start(b)

	else:
		print("IS ALREADY SWITCHING SCENE!!!")


func _thread_load_function(path: String):
	new_scene = ResourceLoader.load(path)


func _deferred_goto_scene(path: String):
	# It is now safe to remove the current scene
	former_scene = current_scene

	new_scene = load(path)
	call_deferred("change_scene", new_scene)

