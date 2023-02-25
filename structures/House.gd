extends Area2D

signal enemy_hidden_in_house(enemy)
signal enemy_revealed(enemy)


var num_players_in_house := 0
var objects_in_house := []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Walls/Roof.show()


func _on_House_body_entered(body: Node) -> void:
	if body.has_method("get_class"):
		if body.get_class() == "Player":
			$Walls/Roof.hide()
			num_players_in_house += 1
			show_objects()

		elif body.get_class() in ["Enemy", "Bullet"]:
			if num_players_in_house <= 0:
				body.hide()

			body.connect("removed_from_scene", self, "_object_removed")
			objects_in_house.append(body)


func _on_House_body_exited(body: Node) -> void:
	if body.has_method("get_class"):
		if body.get_class() == "Player":
			$Walls/Roof.show()
			num_players_in_house -= 1
			if num_players_in_house == 0:
				hide_objects()

		elif body.get_class() in ["Enemy", "Bullet"]:
			body.show()
			body.disconnect("removed_from_scene", self, "_object_removed")
			_object_removed(body)


func _on_House_area_entered(area: Area2D) -> void:
	_on_House_body_entered(area)


func _on_House_area_exited(area: Area2D) -> void:
	_on_House_body_exited(area)


func _object_removed(object):
	objects_in_house.erase(object)


func hide_objects():
	for object in objects_in_house:
		object.hide()


func show_objects():
	for object in objects_in_house:
		object.show()
