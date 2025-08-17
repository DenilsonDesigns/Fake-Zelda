extends CanvasLayer

@onready var rupee_counter: Node = $MarginContainer/RupeeCounter

func _ready():
	GameState.rupee_balance_changed.connect(_on_rupee_changed)
	_on_rupee_changed(GameState.rupee_balance)

func _on_rupee_changed(new_balance: int) -> void:
	rupee_counter.update_balance(new_balance)