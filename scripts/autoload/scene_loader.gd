extends Node

var current_scene: Node = null

func load_scene(scene: PackedScene) -> void:
	if current_scene:
		current_scene.queue_free()
		current_scene = null

	current_scene = scene.instantiate()
	get_tree().root.add_child(current_scene)