extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var head_turn_timer: Timer = $HeadTurnTimer
@onready var agro_area: Area2D = $AgroArea
@onready var link: Node2D = null

@export var min_walk_cycle: int = 2
@export var max_walk_cycle: int = 6
@export var speed: float = 20.0
@export var pursuit_speed_multiplier: float = 1.2

var walk_cycles: int = 0
var current_walk_cycle: int = 0
var head_direction := ""
var movement_direction := "down"

func _ready() -> void:
	walk_cycles = randi_range(min_walk_cycle, max_walk_cycle)
	set_movement_target()
	head_turn_timer.wait_time = randf_range(2.0, 4.0)
	head_turn_timer.start()

func _physics_process(_delta: float) -> void:
	if link:
		follow_link()
	else:
		patrol()

func follow_link() -> void:
	var current_speed = speed * pursuit_speed_multiplier
	var link_direction = (link.global_position - global_position).normalized()
	velocity = link_direction * current_speed
	animated_sprite_2d.flip_h = velocity.x < 0
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
	
	animated_sprite_2d.flip_h = velocity.x < 0
	move_and_slide()

	navigation_agent_2d.velocity = velocity
	if velocity.length() > 0.1:
		movement_direction = get_movement_direction(velocity)
		play_walk_animation(movement_direction)
	else:
		play_idle_animation(movement_direction)

func handle_animation() -> void:
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
	if animated_sprite_2d.animation != anim_name:
		animated_sprite_2d.play(anim_name)

func play_idle_animation(dir: String) -> void:
	var anim_name = "idle_" + dir + head_direction
	if animated_sprite_2d.animation != anim_name:
		animated_sprite_2d.play(anim_name)

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