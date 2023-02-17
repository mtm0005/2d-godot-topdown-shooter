extends Node2D


enum State {
	PATROL,
	ENGAGE,
	FRENZY
}


var current_state: int = -1
var actor: Enemy = null  # set in initialize
var target: KinematicBody2D = null  # set when a Player enters the detection zone
var patrol_location: Vector2 = Vector2.ZERO
var patrol_location_reached: bool = false


var frenzy_direction := 0.0
var frenzy_position := Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()


func initialize(actor: Enemy):
	self.actor = actor
	set_state(State.PATROL)
	actor.connect("hit", self, "_handle_hit")


func get_new_patrol_location() -> Vector2:
	var range_x = rand_range(actor.min_patrol_distance, actor.max_patrol_distance)
	var sign_x = 1
	if (randi() % 2) == 0: sign_x = -1

	var range_y = rand_range(actor.min_patrol_distance, actor.max_patrol_distance)
	var sign_y = 1
	if (randi() % 2) == 0: sign_y = -1

	var new_patrol_position = Vector2(range_x * sign_x, range_y * sign_y) + global_position
	return new_patrol_position


func patrol():
	# If the actor hasn't reached the patrol location, move toward the location
	# If the actor reaches the location then start the patrol timer
	if not patrol_location_reached:
		actor.move_and_slide(actor.velocity_toward(patrol_location))
		actor.rotate_toward(patrol_location)
		if actor.has_reached_position(patrol_location):
			patrol_location_reached = true
			$PatrolTimer.start()

	# If the timer is stopped, set the new patrol location
	elif $PatrolTimer.is_stopped():
		patrol_location = get_new_patrol_location()
		patrol_location_reached = false


func engage(delta):
	if $AttackTimer.is_stopped():
		var target_position = target.global_position
		actor.rotate_toward(target_position)
		var body: KinematicCollision2D = actor.move_and_collide(actor.velocity_toward(target_position) * delta)
		if body != null and body.collider.has_method("handle_hit"):
			body.collider.handle_hit()
			$AttackTimer.start()


func frenzy():
	if actor.has_reached_position(frenzy_position):
		set_state(State.PATROL)
		$DetectionZone/CollisionShape2D.scale = Vector2(1, 1)
	else:
		actor.rotate_toward(frenzy_position)
		actor.move_and_slide(actor.velocity_toward(frenzy_position)*1.25)


func _physics_process(delta: float) -> void:
	match current_state:
		State.PATROL:
			patrol()

		State.ENGAGE:
			engage(delta)

		State.FRENZY:
			frenzy()

		_:
			printerr("invalid enemy state (%d) in AI._process" % current_state)


func set_state(new_state: int):
	if new_state == current_state:
		return

	current_state = new_state
	if current_state == State.PATROL:
		$PatrolTimer.start()
		patrol_location_reached = true

	else:
		$PatrolTimer.stop()

	print("state changed to %d" % current_state)


func _on_DetectionZone_body_entered(body: Node) -> void:
	if current_state != State.ENGAGE and body.get_class() == "Player":
		set_state(State.ENGAGE)
		target = body

		# make the detection zone larger while engaging an enemy
		$DetectionZone/CollisionShape2D.scale = Vector2(1.5, 1.5)


func _on_DetectionZone_body_exited(body: Node) -> void:
	if body == target:
		set_state(State.PATROL)
		target = null
		$DetectionZone/CollisionShape2D.scale = Vector2(1, 1)


func _handle_hit(bullet: Bullet):
	if current_state == State.PATROL:
		set_state(State.FRENZY)
		$DetectionZone/CollisionShape2D.scale = Vector2(1.5, 1.5)

		# Set the direction to the opposite of the bullet
		frenzy_direction = bullet.global_rotation_degrees + 180

		# Add a random value to the direction since the enemy isn't sure exactly
		# where the shooter is.
		var frenzy_offset = rand_range(-25, 25)
		frenzy_direction += frenzy_offset
		frenzy_position.y = global_position.y + 250 * sin(deg2rad(frenzy_direction))
		frenzy_position.x = global_position.x + 250 * cos(deg2rad(frenzy_direction))
