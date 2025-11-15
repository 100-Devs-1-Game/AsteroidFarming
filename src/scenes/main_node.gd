class_name MainNode extends Minigame

@onready var main_camera: MainCamera = $"Main Scene/Main Camera"

@onready var grid_map: Farm = $"Main Scene/GridMap"

func pass_mouse_input():
	var mouse_pos:=get_viewport().get_mouse_position()
	print_debug(mouse_pos)
	main_camera.interact(mouse_pos,true)
