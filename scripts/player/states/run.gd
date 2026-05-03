extends Motion

func _enter() -> void:
	print(name)
	
func _state_input(event: InputEvent) -> void:
	var sprint_threshold := PLAYER_MOVEMENT_STATS.minimum_sprint_threshold
	if event.is_action_pressed("jump"):
		finished.emit("Jump")
	if event.is_action_pressed("sprint") and sprint_remaining > sprint_threshold:
		finished.emit("Sprint")
	if event.is_action_pressed("aim"):
		finished.emit("AimWalk")

func _update(delta: float) -> void:
	set_direction()
	calculate_velocity(speed, direction, PLAYER_MOVEMENT_STATS.acceleration, delta)
	replenish_sprint(delta)
	if direction == Vector3.ZERO:
		finished.emit("Idle")
	if not is_on_floor():
		finished.emit("Fall")
