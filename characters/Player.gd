extends KinematicBody2D
class_name Player


signal player_health_changed(new_health)
signal player_stamina_changed(new_stamina)


export (int) var walk_speed = 100
export (int) var run_speed = 135
export (int) var max_health = 100
export (int) var max_stamina = 750


var health: int = max_health
var stamina: int = max_stamina
var stamina_recovering: bool = false


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

	var speed = walk_speed
	if Input.is_action_pressed("sprint") and stamina > 0:
		stamina_recovering = false
		speed = run_speed
		set_stamina(stamina - 3)
	elif stamina < max_stamina:
		if not stamina_recovering:
			$StaminaCooldownTimer.start()
			stamina_recovering = true
		elif $StaminaCooldownTimer.is_stopped():
			set_stamina(stamina + 2)

	movement_direction = movement_direction.normalized()
	move_and_slide(movement_direction * speed)

	look_at(get_global_mouse_position())


func set_stamina(new_stamina):
	if stamina != new_stamina:
		stamina = clamp(new_stamina, 0, max_stamina)
		emit_signal("player_stamina_changed", stamina)


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
