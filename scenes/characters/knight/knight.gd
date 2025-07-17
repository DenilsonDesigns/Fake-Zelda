extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

@export var min_walk_cycle: int = 2
@export var max_walk_cycle: int = 6
@export var min_speed: float = 5.0
@export var max_speed: float = 10.0

var walk_cycles: int = 0
var current_walk_cycle: int = 0
var speed: float = 0.0

func _ready() -> void:
	walk_cycles = randi_range(min_walk_cycle, max_walk_cycle)
	speed = randf_range(min_speed, max_speed)
	set_movement_target()

func _physics_process(_delta: float) -> void:
	if navigation_agent_2d.is_navigation_finished():
		current_walk_cycle += 1
		if current_walk_cycle < walk_cycles:
			set_movement_target()
		else:
			current_walk_cycle = 0 # Reset cycle
		return

	var target_position: Vector2 = navigation_agent_2d.get_next_path_position()
	var direction: Vector2 = global_position.direction_to(target_position)
	
	velocity = direction * speed
	
	animated_sprite_2d.flip_h = velocity.x < 0
	move_and_slide()

	# Important: update agent velocity so it avoids obstacles
	navigation_agent_2d.velocity = velocity

func set_movement_target() -> void:
	var map_rid = navigation_agent_2d.get_navigation_map()
	var random_point = NavigationServer2D.map_get_random_point(map_rid, navigation_agent_2d.navigation_layers, false)
	navigation_agent_2d.target_position = random_point
