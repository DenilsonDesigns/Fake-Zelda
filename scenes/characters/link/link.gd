extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var speed: float = 100.0

func _physics_process(_delta: float) -> void:
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	velocity = input_vector * speed
	move_and_slide()
	update_animation(input_vector)


func update_animation(dir: Vector2) -> void:
	if dir == Vector2.ZERO:
		animated_sprite_2d.stop()
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
