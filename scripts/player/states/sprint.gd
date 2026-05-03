extends Motion

signal sprint_started
signal sprint_ended

@export var sprint_recharge_delay: float = 2.0

func _enter() -> void:
	sprint_started.emit()
	sprint_recharge_delay_remaining = sprint_recharge_delay
	print(name)
	
func _state_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		finished.emit("SprintJump")
	if event.is_action_released("sprint"):
		sprint_ended.emit()
		finished.emit("Run")

func _update(delta: float) -> void:
	set_direction()
	calculate_velocity(sprint_speed, direction, PLAYER_MOVEMENT_STATS.acceleration, delta)
	sprint_remaining -= delta
	if sprint_remaining <= 0.0:
		sprint_ended.emit()
		finished.emit("Run")
	if direction == Vector3.ZERO:
		finished.emit("Idle")
