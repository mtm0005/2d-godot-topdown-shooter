extends Node2D


func _ready() -> void:
	$Player.initialize($Ground)
	$HUD.set_player($Player)
	$Enemy.initialize($Ground, $House)
	$Enemy2.initialize($Ground, $House)
