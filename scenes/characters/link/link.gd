class_name Link extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var speed: float = 100.0

var last_move_dir: Vector2 = Vector2.DOWN
var is_attacking: bool = false

func _physics_process(_delta: float) -> void:
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	if not is_attacking:
		if input_vector != Vector2.ZERO:
			last_move_dir = input_vector

		velocity = input_vector * speed
		move_and_slide()
		update_animation(input_vector)

	if Input.is_action_just_pressed("attack") and not is_attacking:
		play_sword_animation()

func update_animation(dir: Vector2) -> void:
	if dir == Vector2.ZERO:
		if abs(last_move_dir.x) > abs(last_move_dir.y):
			animated_sprite_2d.animation = "idle_side"
			animated_sprite_2d.flip_h = last_move_dir.x < 0
		elif last_move_dir.y > 0:
			animated_sprite_2d.animation = "idle_down"
			animated_sprite_2d.flip_h = false
		else:
			animated_sprite_2d.animation = "idle_up"
			animated_sprite_2d.flip_h = false

		animated_sprite_2d.play()
		return

	if abs(dir.x) > abs(dir.y):
		animated_sprite_2d.animation = "walk_side"
		animated_sprite_2d.flip_h = dir.x < 0
	elif dir.y > 0:
		animated_sprite_2d.animation = "walk_down"
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.animation = "walk_up"
		animated_sprite_2d.flip_h = false

	animated_sprite_2d.play()

func play_sword_animation():
	is_attacking = true

	var anim_name := ""
	if abs(last_move_dir.x) > abs(last_move_dir.y):
		anim_name = "swing_side"
		animated_sprite_2d.flip_h = last_move_dir.x < 0
	elif last_move_dir.y > 0:
		anim_name = "swing_down"
	else:
		anim_name = "swing_up"

	animated_sprite_2d.play(anim_name)

	await animated_sprite_2d.animation_finished

	is_attacking = false
