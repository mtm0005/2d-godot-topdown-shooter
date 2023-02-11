extends CanvasLayer
class_name HUD


onready var health_bar = $MarginContainer/Rows/BottomRow/ProgressBarSection/ProgressBars/HealthBar
onready var stamina_bar = $MarginContainer/Rows/BottomRow/ProgressBarSection/ProgressBars/StaminaBar
onready var current_ammo = $MarginContainer/Rows/BottomRow/AmmoSection/CurrentAmmo
onready var max_ammo = $MarginContainer/Rows/BottomRow/AmmoSection/MaxAmmo


var player: Player = null


func set_player(player: Player):
	self.player = player

	_set_max_health(player.max_health)
	set_health_value(player.health)

	_set_max_stamina(player.max_stamina)
	set_stamina_value(player.stamina)

	set_max_ammo(player.weapon.max_ammo)
	set_current_ammo(player.weapon.max_ammo)

	player.connect("player_health_changed", self, "set_health_value")
	player.connect("player_stamina_changed", self, "set_stamina_value")
	player.weapon.connect("gun_ammo_changed", self, "set_current_ammo")


func _set_max_health(max_health: int):
	health_bar.max_value = max_health


func set_health_value(health: int):
	health_bar.value = health


func _set_max_stamina(max_stamina: int):
	stamina_bar.max_value = max_stamina


func set_stamina_value(stamina: int):
	stamina_bar.value = stamina


func set_current_ammo(ammo: int):
	current_ammo.text = str(ammo)


func set_max_ammo(ammo: int):
	max_ammo.text = str(ammo)
