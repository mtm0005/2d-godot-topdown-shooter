extends Particles2D


func start_emitting():
	$Timer.wait_time = lifetime
	$Timer.start()
	emitting = true
	print("blood spray is emitting")


func _on_Timer_timeout() -> void:
	print("blood spray is gone")
	queue_free()
