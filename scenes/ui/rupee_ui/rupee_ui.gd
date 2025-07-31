extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	_queue_shine()

func _queue_shine() -> void:
	await get_tree().create_timer(randf_range(4.0, 10.0)).timeout
	animation_player.play("shine")
	await animation_player.animation_finished
	_queue_shine()