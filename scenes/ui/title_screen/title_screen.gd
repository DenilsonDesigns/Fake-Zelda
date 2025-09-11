class_name TitleScreen extends Control

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sword_sprite: AnimatedSprite2D = $MenuContainer/SwordSprite

signal start_game

var sparkle_anims := [
	"sparkle_bottom_left",
	"sparkle_bottom_right",
	"sparkle_top_right",
	"sparkle_top_left"
]
var last_sparkle: String = ""

func _ready() -> void:
	animated_sprite_2d.play("sword_drop")
	animated_sprite_2d.animation_finished.connect(_on_animated_sprite_2d_animation_finished)

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "sword_drop":
		_play_random_sparkle()

func _play_random_sparkle() -> void:
	var anim = sparkle_anims.pick_random()

	while anim == last_sparkle:
		anim = sparkle_anims.pick_random()

	last_sparkle = anim

	animated_sprite_2d.play(anim)
	animated_sprite_2d.animation_finished.connect(_on_sparkle_finished, ConnectFlags.CONNECT_ONE_SHOT)

func _on_sparkle_finished() -> void:
	_play_random_sparkle()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		if event.keycode == KEY_SPACE:
			emit_signal("start_game")
