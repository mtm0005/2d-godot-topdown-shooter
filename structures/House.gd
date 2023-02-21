extends Area2D

signal enemy_hidden_in_house(enemy)
signal enemy_revealed(enemy)


var num_players_in_house := 0
var enemies_in_house := []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Walls/Roof.show()


func _on_House_body_entered(body: Node) -> void:
	if body.has_method("get_class") and body.get_class() == "Player":
		$Walls/Roof.hide()
		num_players_in_house += 1
		show_enemies()

	elif body.has_method("handle_hit"):
		emit_signal("enemy_hidden_in_house", body)
		body.connect("died", self, "_enemey_died")
		enemies_in_house.append(body)


func _on_House_body_exited(body: Node) -> void:
	if body.has_method("get_class") and body.get_class() == "Player":
		$Walls/Roof.show()
		num_players_in_house -= 1
		if num_players_in_house == 0:
			hide_enemies()

	elif body.has_method("handle_hit"):
		emit_signal("enemy_revealed", body)


func _enemey_died(enemy):
	print("removing enemy from house array")
	enemies_in_house.erase(enemy)
	print("done")


func hide_enemies():
	for enemy in enemies_in_house:
		enemy.hide()


func show_enemies():
	for enemy in enemies_in_house:
		enemy.show()
