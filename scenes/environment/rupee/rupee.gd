extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

enum RupeeColor {green, blue, red}
@export var color: RupeeColor = RupeeColor.green

func _ready() -> void:
	var anim_name = RupeeColor.keys()[color]
	animation_player.play(anim_name)