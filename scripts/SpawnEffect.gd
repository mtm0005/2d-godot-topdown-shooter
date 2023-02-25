extends Node


enum Effects {
	BLOOD_SPRAY,
	WOOD_SPLINTERS
}


const effects = {Effects.BLOOD_SPRAY   : preload("res://effects/BloodSpray.tscn"),
				 Effects.WOOD_SPLINTERS: preload("res://effects/WoodSplinters.tscn")}


func spawn_effect(effect, position, rotation):
	var effect_instance = effects[effect].instance()
	get_node("/root/main").add_child(effect_instance)
	effect_instance.global_position = position
	effect_instance.global_rotation = rotation
	effect_instance.start_emitting()
