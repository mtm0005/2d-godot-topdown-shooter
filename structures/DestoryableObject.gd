extends KinematicBody2D
class_name DestroyableObject


export var health := 30


func set_health(h):
	health = h


func handle_hit(_node):
	health -= 20
	if health <= 0:
		queue_free()
