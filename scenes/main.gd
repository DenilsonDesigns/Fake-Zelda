class_name Main extends Node

@onready var current_screen: Node = $CurrentScreen

@export_file("*.tscn") var first_gameplay_scene: String
@export var startup_scene: PackedScene


func _ready() -> void:
	load_first_scene()

func load_first_scene():
	if not startup_scene:
		push_error("No startup_scene assigned in Main.tscn!")
		return

	clear_current_screens()
	var scene_instance = startup_scene.instantiate()
	current_screen.add_child(scene_instance)

	if scene_instance.has_signal("start_game"):
		scene_instance.start_game.connect(_on_start_game.bind(first_gameplay_scene))

func clear_current_screens() -> void:
	for child in current_screen.get_children():
		child.queue_free()

func _on_start_game(next_scene_path: String) -> void:
	var next_scene: PackedScene = load(next_scene_path)
	if not next_scene:
		push_error("Invalid scene path: %s" % next_scene_path)
		return

	clear_current_screens()
	var scene_instance = next_scene.instantiate()
	current_screen.add_child(scene_instance)