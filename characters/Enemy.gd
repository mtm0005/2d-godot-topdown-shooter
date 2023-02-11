extends KinematicBody2D
class_name Enemy


export (int) var walk_speed = 50
export (int) var run_speed = 100
export (float) var min_patrol_distance = 25.0
export (float) var max_patrol_distance = 80.0
export (int) var max_health = 60
var health: int = max_health


func _ready() -> void:
	$AI.initialize(self)


func rotate_toward(location: Vector2):
	var angle_to_location = global_position.direction_to(location).angle()
	rotation = lerp(rotation, angle_to_location, 0.1)


func velocity_toward(location: Vector2) -> Vector2:
	if $AI.current_state == $AI.State.PATROL:
		return global_position.direction_to(location) * walk_speed

	return global_position.direction_to(location) * run_speed


func has_reached_position(location: Vector2) -> bool:
	return global_position.distance_to(location) < 5


func handle_hit():
	health -= 20
	if health <= 0:
		queue_free()
