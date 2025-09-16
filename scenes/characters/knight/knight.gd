extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var head_turn_timer: Timer = $HeadTurnTimer
@onready var agro_area: Area2D = $AgroArea
@onready var link: Node2D = null
@export var min_walk_cycle: int = 2
@export var max_walk_cycle: int = 6
@export var speed: float = 20.0
@export var pursuit_speed_multiplier: float = 1.3
const KNOCKBACK_FORCE = 150.0
const KNOCKBACK_DURATION = 0.2
const MIN_FOLLOW_DISTANCE = 18.0

var walk_cycles: int = 0
var current_walk_cycle: int = 0
var head_direction := ""
var movement_direction := "down"
var health := 3
var invincible = false
var knockback_timer := 0.0

func _ready() -> void:
	walk_cycles = randi_range(min_walk_cycle, max_walk_cycle)
	set_movement_target()
	head_turn_timer.wait_time = randf_range(2.0, 4.0)
	head_turn_timer.start()

func _physics_process(delta: float) -> void:
	if knockback_timer > 0:
		knockback_timer -= delta
		velocity = velocity.move_toward(Vector2.ZERO, 600 * delta)
		move_and_slide()
		return

	if link:
		follow_link(link.global_position)
	else:
		patrol()

func follow_link(link_position: Vector2) -> void:
	if knockback_timer > 0:
		return

	var direction_to_link = link_position - global_position
	var distance_from_link = direction_to_link.length()

	if direction_to_link.length() > MIN_FOLLOW_DISTANCE:
		velocity = direction_to_link.normalized() * speed * pursuit_speed_multiplier
	elif distance_from_link < MIN_FOLLOW_DISTANCE * 0.8:
		velocity = - direction_to_link.normalized() * (speed * 0.5)
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	handle_animation()

func patrol() -> void:
	if navigation_agent_2d.is_navigation_finished():
		current_walk_cycle += 1
		if current_walk_cycle < walk_cycles:
			set_movement_target()
		else:
			current_walk_cycle = 0
		return

	var target_position: Vector2 = navigation_agent_2d.get_next_path_position()
	var direction: Vector2 = global_position.direction_to(target_position)
	
	velocity = direction * speed
	
	sprite_2d.flip_h = velocity.x < 0
	move_and_slide()

	navigation_agent_2d.velocity = velocity
	if velocity.length() > 0.1:
		movement_direction = get_movement_direction(velocity)
		play_walk_animation(movement_direction)
	else:
		play_idle_animation(movement_direction)

func handle_animation() -> void:
	sprite_2d.flip_h = velocity.x < 0

	if velocity.length() > 0.1:
		movement_direction = get_movement_direction(velocity)
		play_walk_animation(movement_direction)
	else:
		play_idle_animation(movement_direction)

func get_movement_direction(vel: Vector2) -> String:
	if abs(vel.x) > abs(vel.y):
		return "side"
	elif vel.y < 0:
		return "up"
	else:
		return "down"

func play_walk_animation(dir: String) -> void:
	var anim_name = "walk_" + dir + head_direction
	if animation_player.current_animation != anim_name:
		animation_player.play(anim_name)

func play_idle_animation(dir: String) -> void:
	var anim_name = "idle_" + dir + head_direction
	if animation_player.current_animation != anim_name:
		animation_player.play(anim_name)

func play_take_damage_animation() -> void:
	var blink_count = 6
	for i in blink_count:
		animation_player.visible = false
		await get_tree().create_timer(0.1).timeout
		animation_player.visible = true
		await get_tree().create_timer(0.1).timeout

func set_movement_target() -> void:
	var map_rid = navigation_agent_2d.get_navigation_map()
	var random_point = NavigationServer2D.map_get_random_point(map_rid, navigation_agent_2d.navigation_layers, false)
	navigation_agent_2d.target_position = random_point

func _on_head_turn_timer_timeout() -> void:
	var options = ["", "_head_left", "_head_right"]
	head_direction = options[randi() % options.size()]
	head_turn_timer.wait_time = randf_range(2.0, 4.0)
	head_turn_timer.start()

func _on_agro_area_body_entered(body: Node2D) -> void:
	if body.name == "Link":
		link = body

func _on_agro_area_body_exited(body: Node2D) -> void:
	if body == link:
		link = null


func take_damage(amount: int, from_position: Vector2) -> void:
	health -= amount

	if invincible: return

	if health <= 0:
		die()

	start_invincibility()
	var knockback_vector = (global_position - from_position).normalized() * KNOCKBACK_FORCE
	velocity += knockback_vector
	knockback_timer = KNOCKBACK_DURATION

func start_invincibility() -> void:
	invincible = true
	await play_take_damage_animation()
	invincible = false

func die() -> void:
	set_physics_process(false)
	set_collision_layer(0)
	set_collision_mask(0)

	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.tween_callback(queue_free)

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.name == "SwordHitBox":
		take_damage(1, area.global_position)
