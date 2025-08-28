class_name Main extends Node

@onready var current_screen: Node = $CurrentScreen

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
		scene_instance.start_game.connect(_on_start_game)

func clear_current_screens() -> void:
	for child in current_screen.get_children():
		child.queue_free()

func _on_start_game() -> void:
	var overworld = preload("res://scenes/test/test_scene_house_exterior.tscn")
	print("starting gayme")
	clear_current_screens()
	var scene_instance = overworld.instantiate()
	current_screen.add_child(scene_instance)
