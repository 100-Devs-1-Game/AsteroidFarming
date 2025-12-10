extends Node3D

func _process(delta: float) -> void:
	if !owner.is_processing(): return
	if Input.is_action_pressed("move_left"):
		rotate_y(-delta)
	elif Input.is_action_pressed("move_right"):
		rotate_y(delta)
