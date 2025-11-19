extends Node

var current_view: Node = null
var views: Dictionary = {}  # path: String -> Node

func _ready() -> void:
	var starting_scene: Node = instantiate_scene("res://Scenes/Scene1.tscn")
	current_view = starting_scene

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("StartGame"):
		switch_scene("res://Scenes/Scene1.tscn")

func switch_scene(path: String)->void:
	# Defer the actual scene tree modifications until after the current
	# frame/physics step. Doing add_child/remove_child while physics is
	# running can cause the physics server to lose the body's space
	# (which produces the `body->get_space() is null` error in player).
	call_deferred("_do_switch", path)

func _do_switch(path: String) -> void:
	# Hide + pause current view (safe to do deferred)
	if current_view and is_instance_valid(current_view):
		current_view.visible = false
		current_view.process_mode = Node.PROCESS_MODE_DISABLED

	var new_view: Node = null

	# If we've already instantiated this scene, reuse it
	if views.has(path) and is_instance_valid(views[path]):
		new_view = views[path]
		# Ensure it's parented under root
		var pv = new_view.get_parent()
		if pv != get_tree().root:
			if pv:
				pv.remove_child(new_view)
			get_tree().root.add_child(new_view)
	else:
		# First time seeing this path: instantiate and cache
		new_view = instantiate_scene(path)
		get_tree().root.add_child(new_view)
		views[path] = new_view

	# Show + unpause new view
	new_view.visible = true
	new_view.process_mode = Node.PROCESS_MODE_INHERIT

	# Set as current scene (must be direct child of root)
	get_tree().current_scene = new_view

	current_view = new_view

func instantiate_scene(path: String) -> Node:
	var packed_scene: PackedScene = load(path)
	var instantiated_scene: Node = packed_scene.instantiate()
	return instantiated_scene
