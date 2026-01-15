class_name Player
extends Node3D

@export var front_collision_ray: RayCast3D
@export var back_collision_ray: RayCast3D
@export var left_collision_ray: RayCast3D
@export var right_collision_ray: RayCast3D

const TRAVEL_TIME: float = 0.3
const TURN_DISTANCE: float = PI / 2.0
const TURN_TIME: float = 0.2
const SLOPE_TIME: float = 1.0

# Optional to prevent movement such as in cutscenes or other scripted events
static var can_move: bool = true

var movement_tween: Tween


func _physics_process(_delta: float) -> void:
	if not can_move:
		return
	if movement_tween and movement_tween.is_running():
		return
	if not Input.is_anything_pressed():
		return
	else:
		if Input.is_action_pressed("move_forward") and not front_collision_ray.is_colliding():
			_move_player(Vector3i.FORWARD)
		if Input.is_action_pressed("move_back") and not back_collision_ray.is_colliding():
			_move_player(Vector3i.BACK)
		if Input.is_action_pressed("move_left") and not left_collision_ray.is_colliding():
			_move_player(Vector3i.LEFT)
		if Input.is_action_pressed("move_right") and not right_collision_ray.is_colliding():
			_move_player(Vector3i.RIGHT)
		
		if Input.is_action_just_pressed("turn_left"):
			_turn_player(Vector3i.UP)
		if Input.is_action_just_pressed("turn_right"):
			_turn_player(Vector3i.DOWN)


@warning_ignore_start("return_value_discarded")
func _move_player(direction: Vector3i) -> void:
	if movement_tween:
		movement_tween.kill()
	movement_tween = create_tween()
	movement_tween.tween_property(self, "transform", transform.translated_local(direction * 2), TRAVEL_TIME)


func _turn_player(direction: Vector3i) -> void:
	if movement_tween:
		movement_tween.kill()
	movement_tween = create_tween()
	movement_tween.tween_property(self, "transform", transform.rotated_local(direction, TURN_DISTANCE), TURN_TIME)
@warning_ignore_restore("return_value_discarded")
