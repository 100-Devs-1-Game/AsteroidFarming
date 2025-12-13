extends Node3D

func _process(delta: float) -> void:
	if !owner.is_processing(): return
	var value = delta
	if Input.is_action_pressed("shift"):
		value *= 3
	if Input.is_action_pressed("move_left"):
		rotate_y(-value)
	elif Input.is_action_pressed("move_right"):
		rotate_y(value)
