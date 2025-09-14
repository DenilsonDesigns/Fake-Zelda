# @TODO: export to own scene separate from field_UI
class_name HeartRow extends HBoxContainer

@export var heart_scene: PackedScene
# @TODO: move this to game_state
@export var max_health: int = 3
@export var current_health: int = 3: set = set_current_health

func _ready() -> void:
	_generate_hearts()
	_update_hearts()

func set_current_health(value: int) -> void:
	current_health = clamp(value, 0, max_health)
	_update_hearts()

func _generate_hearts() -> void:
	for child in get_children():
		child.queue_free()

	for i in range(max_health):
		var heart: LifeBarHeart = heart_scene.instantiate()
		add_child(heart)
		print("Added heart:", i) # 👈 Debug

func _update_hearts() -> void:
	for i in range(max_health):
		var heart: LifeBarHeart = get_child(i)
		heart.full = i < current_health
