extends Area2D





func _on_Bush_body_entered(body: Node) -> void:
	# TODO - think of a good way to make the player harder to see in bushes
	# TODO - consider adding new audio for players walking bushes
	if body.has_method("is_camoable"):
		pass
