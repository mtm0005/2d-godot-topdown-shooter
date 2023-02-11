extends KinematicBody2D
class_name Player


signal player_health_changed(new_health)


export (int) var walk_speed = 100
export (int) var run_speed = 135
export (int) var max_health = 100


var health: int = max_health


onready var camera = $Camera2D
onready var weapon: Gun = $Gun;


func _physics_process(delta: float) -> void:
	var movement_direction = Vector2.ZERO

	if Input.is_action_pressed("up"):
		movement_direction.y += -1
	if Input.is_action_pressed("down"):
		movement_direction.y += 1
	if Input.is_action_pressed("left"):
		movement_direction.x += -1
	if Input.is_action_pressed("right"):
		movement_direction.x += 1

	var speed = run_speed if Input.is_action_pressed("sprint") else walk_speed

	movement_direction = movement_direction.normalized()
	move_and_slide(movement_direction * speed)

	look_at(get_global_mouse_position())


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		attack()
	elif event.is_action_pressed("reload"):
		reload()


func get_class() -> String:
	return "Player"


func attack():
	weapon.attack()


func reload():
	weapon.start_reload()


func handle_hit():
	health -= 20
	emit_signal("player_health_changed", health)
	if health <= 0:
		#queue_free()
		print('player should die')
		health = max_health
