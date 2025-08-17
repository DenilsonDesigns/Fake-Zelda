class_name Main extends Node

@onready var current_screen: Node = $CurrentScreen

# @NOTE: this would be a transition node to play fade ins/outs etc
# @onready var transition_layer: Node = $TransitionLayer

@export var startup_scene: PackedScene

func _ready() -> void:
	load_first_scene()


func load_first_scene():
	if not startup_scene:
		push_error("No startup_scene assigned in Main.tscn!")
		return

	clear_current_screens()

	instantiate_startup_scene()

func clear_current_screens() -> void:
	for child in current_screen.get_children():
		child.queue_free()

func instantiate_startup_scene() -> void:
	var scene_instance = startup_scene.instantiate()
	current_screen.add_child(scene_instance)


func switch_scene(new_scene: PackedScene) -> void:
	clear_current_screens()

	var new_scene_instance = new_scene.instantiate()
	current_screen.add_child(new_scene_instance)
