# @TODO: export to own scene separate from field_UI
class_name HeartRow extends HBoxContainer

@export var heart_scene: PackedScene

func _ready() -> void:
	GameState.health_changed.connect(_on_health_changed)
	_generate_hearts(GameState.max_health)
	_update_hearts(GameState.current_health, GameState.max_health)

func _on_health_changed(current: int, max_health: int)-> void:
	if max_health != get_child_count():
		_generate_hearts(max_health)
	_update_hearts(current, max_health)

func _generate_hearts(max_health: int) -> void:
	for child in get_children():
		child.queue_free()

	for i in range(max_health):
		var heart: LifeBarHeart = heart_scene.instantiate()
		add_child(heart)

func _update_hearts(current_health: int, max_health: int) -> void:
	for i in range(max_health):
		var heart: LifeBarHeart = get_child(i)
		heart.full = i < current_health