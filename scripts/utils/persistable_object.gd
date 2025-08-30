class_name PersistableObject extends Node2D

@export var object_id: String = ""

func _ready() -> void:
	if object_id.is_empty():
		push_error("PersistableObject has no object_id set: %s" % self.name)
		return
	
	if GameState.is_object_flagged(object_id):
		_on_already_flagged()
	else:
		_on_fresh_spawn()

func _on_already_flagged() -> void:
	queue_free()
	# this queue free may not work, may have to handle in the instance

func _on_fresh_spawn() -> void:
	pass

func mark_persisted() -> void:
	GameState.set_object_flagged(object_id, true)
	# gpt says to queue_free  here, but prefer to handle that in the instance.
