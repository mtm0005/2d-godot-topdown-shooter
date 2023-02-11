extends CanvasLayer
class_name HUD


onready var health_bar = $MarginContainer/Rows/BottomRow/ProgressBarSection/ProgressBars/HealthBar
onready var current_ammo = $MarginContainer/Rows/BottomRow/AmmoSection/CurrentAmmo
onready var max_ammo = $MarginContainer/Rows/BottomRow/AmmoSection/MaxAmmo


var player: Player = null


func set_player(player: Player):
	self.player = player

	set_health_value(player.health)
	set_max_ammo(player.weapon.max_ammo)
	set_current_ammo(player.weapon.max_ammo)

	player.connect("player_health_changed", self, "set_health_value")
	player.weapon.connect("gun_fired", self, "set_current_ammo")


func set_health_value(health: int):
	health_bar.value = health


func set_current_ammo(ammo: int):
	current_ammo.text = str(ammo)


func set_max_ammo(ammo: int):
	max_ammo.text = str(ammo)
