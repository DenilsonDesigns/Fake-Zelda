class_name Rupee extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var color: RupeeColor

enum RupeeColor {green, blue, red}

func _ready() -> void:
	play_shine_animation()
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Link":
		var value
		match color:
			RupeeColor.green:
				value = 1
			RupeeColor.blue:
				value = 5
			RupeeColor.red:
				value = 20
			_:
				value = 0

		GameState.add_rupees(value)
		queue_free()

func play_spawn_animation() -> void:
	animation_player.play("spawn_from_drop_" + rupee_color())
	await animation_player.animation_finished
	play_shine_animation()

func play_shine_animation() -> void:
	animation_player.play("shine_" + rupee_color())

func rupee_color() -> String:
	return RupeeColor.keys()[color]