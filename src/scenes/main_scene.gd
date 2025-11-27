class_name AsteroidFarmingMainScene
extends Node3D

@onready var main_camera: MainCamera = $"Main Camera"
@onready var grid_map: Farm = $"GridMap"

signal sig_harvested
signal sig_lost(count:int)

func pass_mouse_input():
	var mouse_pos:=get_viewport().get_mouse_position()
	main_camera.interact(mouse_pos,true)

func choose_tool(ind:int):
	self.grid_map.choose_tool(ind)

func _on_grid_map_sig_harvested() -> void:
	sig_harvested.emit()
	


func _on_grid_map_sig_lost(count: int) -> void:
	sig_lost.emit(count)
