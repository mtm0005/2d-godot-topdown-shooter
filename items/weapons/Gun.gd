extends Node2D
class_name Gun


signal gun_ammo_changed(new_ammo_count)
signal gun_out_of_ammo


export (PackedScene) var Bullet
#const Bullet = preload("Bullet.tscn")
export (int) var max_ammo = 5


onready var end_of_gun = $EndOfGun
onready var gun_direction = $GunDirection


var current_ammo: int = max_ammo setget set_current_ammo


func _ready():
	$MuzzleFlash.hide()


func attack():
	if $ShotCooldown.is_stopped() and current_ammo > 0:
		$GunAudio.play_gunshot()
		$ShotCooldown.start()
		var bullet_direction = gun_direction.global_position - end_of_gun.global_position
		var bullet: Bullet = Bullet.instance()
		bullet.initialize(end_of_gun.global_position, bullet_direction.normalized())
		get_node("/root/main").add_child(bullet)
		$AnimationPlayer.play("muzzle_flash")
		set_current_ammo(current_ammo - 1)
		emit_signal("gun_ammo_changed", current_ammo)
		if current_ammo <= 0:
			emit_signal("gun_out_of_ammo")


func start_reload():
	$AnimationPlayer.play("reload")


# Called at the end of the reload animation
func _stop_reload():
	current_ammo = max_ammo
	emit_signal("gun_ammo_changed", current_ammo)


func set_current_ammo(ammo: int):
	current_ammo = clamp(ammo, 0, max_ammo)



func _on_AudioStreamPlayer2D_finished() -> void:
	print("audio finished playing")
