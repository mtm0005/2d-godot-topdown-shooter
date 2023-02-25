extends Node2D


func _ready() -> void:
	$Player.initialize($Ground)
	$HUD.set_player($Player)
	$Enemy.initialize($Ground)
	$Enemy2.initialize($Ground)
