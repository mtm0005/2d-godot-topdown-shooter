extends Particles2D


func start_emitting():
	$Timer.wait_time = lifetime
	$Timer.start()
	emitting = true


func _on_Timer_timeout() -> void:
	queue_free()
