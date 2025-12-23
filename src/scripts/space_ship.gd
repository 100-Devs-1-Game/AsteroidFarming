extends Node3D

var prev_pos: Vector3
var dir: Vector3


func _physics_process(delta: float) -> void:
	var vec:= global_position - prev_pos
	if not vec.is_zero_approx():
		dir= vec.normalized()
	
	if dir.length() > delta:
		look_at(position - dir)
	
	prev_pos = global_position
