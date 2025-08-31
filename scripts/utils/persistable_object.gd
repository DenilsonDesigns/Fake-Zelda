class_name PersistableObject extends Node2D

@export var object_id: String = ""

var _resolved_id: String

func _ready() -> void:
	_resolved_id = _make_id()
	print(name, " ready, resolved_id=", _resolved_id)
	
	if GameState.is_object_flagged(_resolved_id):
		_on_already_flagged()
	else:
		_on_fresh_spawn()

func _on_already_flagged() -> void:
	queue_free()
	# this queue free may not work, may have to handle in the instance

func _on_fresh_spawn() -> void:
	pass

func mark_persisted() -> void:
	print("setting flagged")
	GameState.set_object_flagged(_resolved_id, true)
	queue_free()
	# gpt says to queue_free  here, but prefer to handle that in the instance.

func _make_id() -> String:
	if not object_id.is_empty():
		return object_id

	var scene_name := owner.scene_file_path.get_file().get_basename()
	return "%s:%s" % [scene_name, name]
