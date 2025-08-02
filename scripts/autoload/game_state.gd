extends Node

var rupee_balance: int = 0

signal rupee_balance_changed(new_balance: int)

func add_rupees(amount: int) -> void:
	rupee_balance += amount
	rupee_balance_changed.emit(rupee_balance)
