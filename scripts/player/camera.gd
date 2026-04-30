extends Node3D

enum CameraAlignment {
	LEFT = -1,
	RIGHT = 1,
	CENTER = 0
}

@export var character: CharacterBody3D
@export var edge_spring_arm: SpringArm3D
@export var rear_spring_arm: SpringArm3D
@export var camera: Camera3D
@export var camera_alignment_speed := 0.2
@export var aim_rear_spring_length := 0.5
@export var aim_edge_spring_length := 0.5
@export var aim_speed := 0.2
@export var aim_fov: float = 55
@export var sprint_fov := 90.0
@export var sprint_tween_speed := 0.5

@onready var default_edge_spring_arm_length := edge_spring_arm.spring_length
@onready var default_rear_spring_arm_length := rear_spring_arm.spring_length
@onready var default_fov := camera.fov

var camera_rotation := Vector2.ZERO
var mouse_sensitivity := 0.004
var max_y_rotation := 1.2
var camera_tween: Tween
var current_camera_alignment := CameraAlignment.RIGHT

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event is InputEventMouseMotion:
		var mouse_event: Vector2 = event.screen_relative * mouse_sensitivity
		camera_look(mouse_event)
	if event.is_action_pressed("swap_camera_alignment"):
		swap_camera_alignment()
	if event.is_action_pressed("aim"):
		enter_aim()
	if event.is_action_released("aim"):
		exit_aim()
	if event.is_action_pressed("sprint"):
		enter_sprint()
	if event.is_action_released("sprint"):
		exit_sprint()

func camera_look(mouse_movement: Vector2) -> void:
	camera_rotation += mouse_movement
	transform.basis = Basis()
	character.transform.basis = Basis()
	character.rotate_object_local(Vector3(0, 1, 0), -camera_rotation.x)
	rotate_object_local(Vector3(1, 0, 0), -camera_rotation.y)
	camera_rotation.y = clamp(camera_rotation.y, -max_y_rotation, max_y_rotation)

func swap_camera_alignment() -> void:
	match current_camera_alignment:
		CameraAlignment.RIGHT:
			set_current_camera_alignment(CameraAlignment.LEFT)
		CameraAlignment.LEFT:
			set_current_camera_alignment(CameraAlignment.RIGHT)
		CameraAlignment.CENTER:
			return
	var new_position: float = default_edge_spring_arm_length * current_camera_alignment
	set_rear_spring_arm_position(new_position, camera_alignment_speed)

func set_current_camera_alignment(alignment: CameraAlignment) -> void:
	current_camera_alignment = alignment

func set_rear_spring_arm_position(pos: float, speed: float) -> void:
	if camera_tween:
		camera_tween.kill()
	camera_tween = get_tree().create_tween()
	camera_tween.set_trans(Tween.TRANS_EXPO)
	camera_tween.set_ease(Tween.EASE_OUT)
	camera_tween.tween_property(edge_spring_arm, "spring_length", pos, speed)

func enter_aim() -> void:
	if camera_tween:
		camera_tween.kill()
	camera_tween = get_tree().create_tween()
	camera_tween.set_parallel()
	camera_tween.set_trans(Tween.TRANS_EXPO)
	camera_tween.set_ease(Tween.EASE_OUT)
	camera_tween.tween_property(camera, "fov", aim_fov, aim_speed)
	camera_tween.tween_property(edge_spring_arm, "spring_length", aim_edge_spring_length * current_camera_alignment, aim_speed)
	camera_tween.tween_property(rear_spring_arm, "spring_length", aim_rear_spring_length, aim_speed)

func exit_aim() -> void:
	if camera_tween:
		camera_tween.kill()
	camera_tween = get_tree().create_tween()
	camera_tween.set_parallel()
	camera_tween.set_trans(Tween.TRANS_EXPO)
	camera_tween.set_ease(Tween.EASE_OUT)
	camera_tween.tween_property(camera, "fov", default_fov, aim_speed)
	camera_tween.tween_property(edge_spring_arm, "spring_length", default_edge_spring_arm_length * current_camera_alignment, aim_speed)
	camera_tween.tween_property(rear_spring_arm, "spring_length", default_rear_spring_arm_length, aim_speed)

func enter_sprint() -> void:
	if camera_tween:
		camera_tween.kill()
	camera_tween = get_tree().create_tween()
	camera_tween.set_parallel()
	camera_tween.set_trans(Tween.TRANS_EXPO)
	camera_tween.set_ease(Tween.EASE_OUT)
	camera_tween.tween_property(camera, "fov", sprint_fov, sprint_tween_speed)
	camera_tween.tween_property(edge_spring_arm, "spring_length", default_edge_spring_arm_length * current_camera_alignment, aim_speed)
	camera_tween.tween_property(rear_spring_arm, "spring_length", default_rear_spring_arm_length, aim_speed)

func exit_sprint() -> void:
	if camera_tween:
		camera_tween.kill()
	camera_tween = get_tree().create_tween()
	camera_tween.set_parallel()
	camera_tween.set_trans(Tween.TRANS_EXPO)
	camera_tween.set_ease(Tween.EASE_OUT)
	camera_tween.tween_property(camera, "fov", default_fov, sprint_tween_speed)
	camera_tween.tween_property(edge_spring_arm, "spring_length", default_edge_spring_arm_length * current_camera_alignment, aim_speed)
	camera_tween.tween_property(rear_spring_arm, "spring_length", default_rear_spring_arm_length, aim_speed)
