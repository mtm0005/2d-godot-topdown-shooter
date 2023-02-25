extends KinematicBody2D
class_name DestroyableObject


enum MaterialType {
	WOOD,
	NOTHING
}


export var health := 30
export (MaterialType) var material_type = MaterialType.WOOD


func set_health(h):
	health = h


func spawn_particles(node_causing_particles):
	match material_type:
		MaterialType.WOOD:
			SpawnEffect.spawn_effect(SpawnEffect.Effects.WOOD_SPLINTERS,
									 global_position, node_causing_particles.global_rotation)
		MaterialType.NOTHING:
			print("nothing")
		_:
			printerr("Invalid material_type %s" % material_type)


func handle_hit(node):
	health -= 20
	spawn_particles(node)
	if health <= 0:
		queue_free()
