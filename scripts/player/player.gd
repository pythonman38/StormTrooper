extends CharacterBody3D

func set_velocity_from_motion(_velocity: Vector3) -> void:
	velocity = _velocity

func _physics_process(_delta: float) -> void:
	move_and_slide()
