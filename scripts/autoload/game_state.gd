extends Node

var rupee_balance: int = 0

var object_states: Dictionary = {}

signal rupee_balance_changed(new_balance: int)

func add_rupees(amount: int) -> void:
	rupee_balance += amount
	rupee_balance_changed.emit(rupee_balance)

func is_object_flagged(object_id: String) -> bool:
	return object_states.get(object_id, false)

func set_object_flagged(object_id: String, value: bool = true) -> void:
	object_states[object_id] = value
