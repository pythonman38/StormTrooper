extends Resource
class_name MovementStats

@export var time_to_jump_apex: float = 0.5
@export var time_to_land: float = 0.5
@export var jump_height: float = 1.0
@export var jump_distance: float = 4.0
@export var sprint_jump_distance: float = 7.0
@export var aim_jump_distance: float = 1.0
@export var acceleration: float = 100.0
@export var in_air_acceleration: float = 5.0
@export var sprint_duration: float = 3.0
@export var minimum_sprint_threshold: float = 0.5

func get_jump_gravity() -> float:
	return (2 * jump_height) / pow(time_to_jump_apex, 2)

func get_fall_gravity() -> float:
	return (2 * jump_height) / pow(time_to_land, 2)

func get_jump_velocity(gravity: float) -> float:
	return gravity * time_to_jump_apex

func get_velocity(_distance: float, jump_time: float) -> float:
	return _distance / jump_time
