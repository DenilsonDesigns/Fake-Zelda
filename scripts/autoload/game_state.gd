extends Node

var object_states: Dictionary = {}

var rupee_balance: int = 0

var max_health: int = 3
var current_health: int = 3

signal rupee_balance_changed(new_balance: int)
signal health_changed(current: int, max: int)

func add_rupees(amount: int) -> void:
	rupee_balance += amount
	rupee_balance_changed.emit(rupee_balance)

func is_object_flagged(object_id: String) -> bool:
	return object_states.get(object_id, false)

func set_object_flagged(object_id: String, value: bool = true) -> void:
	object_states[object_id] = value

func set_health(value: int) -> void:
	current_health = clamp(value, 0, max_health)
	health_changed.emit(current_health, max_health)

func add_health(amount: int) -> void:
	set_health(current_health + amount)

func set_max_health(value: int) -> void:
	max_health = max(value, 1)
	current_health = clamp(current_health, 0, max_health)
	health_changed.emit(current_health, max_health)