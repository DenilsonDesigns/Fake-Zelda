extends StaticBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hit_box: Area2D = $HitBox
@onready var hit_box_shape: CollisionShape2D = $HitBox/HitBoxShape

@export var dead_shrubs_container: Node2D

func _ready() -> void:
	if not dead_shrubs_container:
		assert(dead_shrubs_container, "dead_shrub_container required")
		queue_free()
		return
	hit_box.connect("area_entered", _on_hit_box_area_entered)

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.name == "SwordHitBox":
		die()

func die():
	animated_sprite_2d.play("destroy")
	hit_box_shape.disabled = true
	hit_box.set_deferred("monitoring", false)
	collision_shape_2d.set_deferred("disabled", true)
	await animated_sprite_2d.animation_finished

	get_parent().remove_child(self)
	dead_shrubs_container.add_child(self)
	global_position = global_position
