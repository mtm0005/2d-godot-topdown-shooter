extends KinematicBody2D
class_name Enemy


signal hit(bullet)
signal died(enemy)


export (int) var walk_speed = 50
export (int) var run_speed = 100
export (float) var min_patrol_distance = 25.0
export (float) var max_patrol_distance = 80.0
export (int) var max_health = 60
var health: int = max_health


var level_tilemap: TileMap = null
const WATER_MOVEMENT_SOUND = preload("res://assets/audio/person-walking-in-water-47854.mp3")
var previous_position := Vector2.ZERO


func _ready() -> void:
	$AI.initialize(self)
	previous_position = global_position


func _physics_process(delta: float) -> void:
	if previous_position != global_position:
		if _in_water():
			_play_water_movement_audio()
		elif $MovementAudioPlayer.is_playing():
			_stop_water_movement_audio()


func initialize(tilemap: TileMap, house: Area2D):
	level_tilemap = tilemap
	house.connect("enemy_hidden_in_house", self, "_hide")
	house.connect("enemy_revealed", self, "_show")


func rotate_toward(location: Vector2):
	var angle_to_location = global_position.direction_to(location).angle()
	rotation = lerp(rotation, angle_to_location, 0.1)


func velocity_toward(location: Vector2) -> Vector2:
	var speed = walk_speed
	if $AI.current_state != $AI.State.PATROL:
		speed = run_speed

	if _in_water():
		speed *= 0.75

	return global_position.direction_to(location) * speed


func has_reached_position(location: Vector2) -> bool:
	return global_position.distance_to(location) < 5


func handle_hit(bullet: Bullet):
	emit_signal("hit", bullet)
	health -= 20
	if health <= 0:
		emit_signal("died", self)
		queue_free()


func _in_water() -> bool:
	var local_position = level_tilemap.to_local(global_position)
	var map_position = level_tilemap.world_to_map(local_position)
	var tile_id = level_tilemap.get_cell(map_position.x, map_position.y)
	if level_tilemap.tile_set.tile_get_name(tile_id) == "water":
		return true

	return false


func _play_water_movement_audio():
	$MovementAudioPlayer/Timer.start()
	if not $MovementAudioPlayer.is_playing():
		$MovementAudioPlayer.stream = WATER_MOVEMENT_SOUND
		$MovementAudioPlayer.play(rand_range(0.0, $MovementAudioPlayer.stream.get_length()))


func _stop_water_movement_audio():
	if $MovementAudioPlayer/Timer.is_stopped():
		$MovementAudioPlayer.stop()


func _hide(enemy):
	if enemy == self:
		self.hide()


func _show(enemy):
	if enemy == self:
		self.show()
