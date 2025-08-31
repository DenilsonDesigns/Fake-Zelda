class_name PersistableObject extends Node2D

@export var object_id: String = ""

var _resolved_id: String

func _ready() -> void:
	_resolved_id = _make_id()

	
	if GameState.is_object_flagged(_resolved_id):
		_on_already_flagged()
	else:
		_on_fresh_spawn()

func _on_already_flagged() -> void:
	queue_free()

func _on_fresh_spawn() -> void:
	pass

func mark_persisted_and_queue_free() -> void:
	GameState.set_object_flagged(_resolved_id, true)
	queue_free()

func mark_persisted() -> void:
	GameState.set_object_flagged(_resolved_id, true)

func _make_id() -> String:
	if not object_id.is_empty():
		return object_id

	var scene_name := "unknown"
	if owner and owner.scene_file_path != "":
		scene_name = owner.scene_file_path.get_file().get_basename()

	return "%s:%s" % [scene_name, name]
