extends StaticBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $HitBox/CollisionShape2D

func _ready() -> void:
	$HitBox.connect("area_entered", _on_hit_box_area_entered)

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.name == "SwordHitBox":
		die()

func die():
	animated_sprite_2d.play("destroy")
	collision_shape_2d.disabled = true
	$HitBox.set_deferred("monitoring", false)
	await animated_sprite_2d.animation_finished
