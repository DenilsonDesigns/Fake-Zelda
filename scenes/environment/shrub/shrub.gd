class_name Shrub extends PersistableObject

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hit_box: Area2D = $HitBox
@onready var hit_box_shape: CollisionShape2D = $HitBox/HitBoxShape

@export var dead_shrubs_container: Node2D
@export_range(0.0, 1.0) var rupee_drop_chance: float = 0.25

var RupeeScene := preload("res://scenes/environment/rupee/rupee.tscn")

func _ready() -> void:
	if not dead_shrubs_container:
		assert(dead_shrubs_container, "dead_shrub_container required")
		queue_free()
		return

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.name == "SwordHitBox":
		die()

func die():
	animated_sprite_2d.play("destroy")
	hit_box_shape.disabled = true
	hit_box.set_deferred("monitoring", false)
	collision_shape_2d.set_deferred("disabled", true)
	await animated_sprite_2d.animation_finished

	convert_to_dead_shrub()
	handle_rupee_spawn()

func convert_to_dead_shrub() -> void:
	get_parent().remove_child(self)
	dead_shrubs_container.add_child(self)

func handle_rupee_spawn() -> void:
	if randf() < rupee_drop_chance:
		var rupee = RupeeScene.instantiate()
		rupee.color = pick_random_rupee_color()
		rupee.position = position
		get_parent().add_child(rupee)
		rupee.play_spawn_animation()

func pick_random_rupee_color() -> Rupee.RupeeColor:
	var roll = randi() % 100
	if roll < 70:
		return Rupee.RupeeColor.green
	elif roll < 90:
		return Rupee.RupeeColor.blue
	else:
		return Rupee.RupeeColor.red
