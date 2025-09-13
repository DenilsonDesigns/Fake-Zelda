class_name TitleScreen extends Control

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sword_sprite: AnimatedSprite2D = $MenuContainer/SwordSprite
@onready var button_container: VBoxContainer = $MenuContainer/ButtonContainer
@onready var buttons: Array[Node] = button_container.get_children()
@onready var sword_container: Control = $MenuContainer/SwordContainer

signal start_game

var sparkle_anims := [
	"sparkle_bottom_left",
	"sparkle_bottom_right",
	"sparkle_top_right",
	"sparkle_top_left"
]
var last_sparkle: String = ""
var selected_index := 0

func _ready() -> void:
	animated_sprite_2d.play("sword_drop")
	animated_sprite_2d.animation_finished.connect(_on_animated_sprite_2d_animation_finished)
	update_sword()

	buttons[0].pressed.connect(_on_new_game_pressed)
	buttons[1].pressed.connect(_on_quit_pressed)

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

func _on_new_game_pressed() -> void:
	emit_signal("start_game")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		selected_index = (selected_index + 1) % buttons.size()
		update_sword()
	elif event.is_action_pressed("ui_up"):
		selected_index = (selected_index - 1 + buttons.size()) % buttons.size()
		update_sword()
	elif event.is_action_pressed("ui_accept") or (event is InputEventKey and event.is_pressed() and not event.is_echo() and event.keycode == KEY_SPACE):
		buttons[selected_index].emit_signal("pressed")

func update_sword() -> void:
	var btn: Button = buttons[selected_index]
	sword_container.position.y = btn.position.y
