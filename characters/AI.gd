extends Node2D


enum State {
	PATROL,
	ENGAGE
}


var current_state: int = -1
var actor: Enemy = null  # set in initialize
var target: KinematicBody2D = null  # set when a Player enters the detection zone
var patrol_location: Vector2 = Vector2.ZERO
var patrol_location_reached: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()


func initialize(actor: Enemy):
	self.actor = actor
	set_state(State.PATROL)


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


func _physics_process(delta: float) -> void:
	match current_state:
		State.PATROL:
			patrol()

		State.ENGAGE:
			engage(delta)

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
