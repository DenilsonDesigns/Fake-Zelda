extends Control

@onready var label: Label = $Label

func update_balance(new_balance: int) -> void:
	label.text = str(new_balance)