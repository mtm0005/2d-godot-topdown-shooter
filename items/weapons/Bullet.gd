extends Area2D
class_name Bullet


export (int) var speed = 10
export (float) var bullet_range = 600.0


var start_position := Vector2.ZERO
var direction := Vector2.ZERO

#func _init(start_position, direction) -> void:
func initialize(start_position, direction) -> void:
	position = start_position
	self.start_position = global_position
	self.direction = direction
	rotation += direction.angle()
	visible = true


func _physics_process(delta: float) -> void:
	var velocity = direction * speed
	global_position += velocity

	# Destroy the bullet if needed
	if position.distance_to(start_position) > bullet_range:
		queue_free()


func _on_Bullet_body_entered(body: Node) -> void:
	if body.has_method("handle_hit"):
		body.handle_hit(self)

	queue_free()
