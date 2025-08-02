extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

enum RupeeColor {green, blue, red}
@export var color: RupeeColor = RupeeColor.green

func _ready() -> void:
	var anim_name = RupeeColor.keys()[color]
	animation_player.play(anim_name)
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
