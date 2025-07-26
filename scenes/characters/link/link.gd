class_name Link extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

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
			$Sprite2D.flip_h = last_move_dir.x < 0
			animation_player.play("idle_side")
		elif last_move_dir.y > 0:
			$Sprite2D.flip_h = false
			animation_player.play("idle_down")
		else:
			$Sprite2D.flip_h = false
			animation_player.play("idle_up")
		return

	if abs(dir.x) > abs(dir.y):
		$Sprite2D.flip_h = dir.x < 0
		animation_player.play("walk_side")
	elif dir.y > 0:
		$Sprite2D.flip_h = false
		animation_player.play("walk_down")
	else:
		$Sprite2D.flip_h = false
		animation_player.play("walk_up")


func play_sword_animation():
	is_attacking = true

	var anim_name := ""
	if abs(last_move_dir.x) > abs(last_move_dir.y):
		anim_name = "swing_side"
		$Sprite2D.flip_h = last_move_dir.x < 0
	elif last_move_dir.y > 0:
		anim_name = "swing_down"
	else:
		anim_name = "swing_up"

	animation_player.play(anim_name)
	await animation_player.animation_finished
	is_attacking = false
