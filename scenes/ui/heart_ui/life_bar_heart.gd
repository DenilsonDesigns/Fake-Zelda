class_name LifeBarHeart extends Control

@export var full: bool = true: set = set_full

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	set_full(full)

func set_full(value: bool) -> void:
	full = value
	if full:
		sprite.play("full")
	else:
		sprite.play("empty")
