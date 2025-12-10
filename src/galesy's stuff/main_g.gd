extends Node3D

@onready var cam: Camera3D = $"camera pivot/cam"
@onready var farmland: GridMap = $Farmland
var active_tool = 0
const TargetPlane = Plane.PLANE_XZ

@onready var uilayer: CanvasLayer = $CanvasLayer

const PLANT_TIME = 6.0
var plants: Dictionary[Vector3i, float] = {}

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("change_tool"):
		active_tool = wrapi(active_tool + 1, 0, 4)
	if Input.is_action_just_pressed("click"):
		#Step 1, get target tile. 
		var tile_target = null
		var mousepos = get_viewport().get_mouse_position()
		var result = TargetPlane.intersects_ray(cam.project_ray_origin(mousepos), cam.project_ray_normal(mousepos))
		if result:
			result += Vector3.DOWN / 2
			tile_target = farmland.local_to_map(farmland.to_local(result))
			print(tile_target)
		#Step 2, apply tool effect to target tile
		if farmland.get_used_cells().has(tile_target):
			match active_tool:
				0: # Bucket
					if farmland.get_cell_item(tile_target) == 1:
						farmland.set_cell_item(tile_target, 2)
					elif farmland.get_cell_item(tile_target) == 2:
						farmland.set_cell_item(tile_target, 1)
				1:  # Shovel
					if farmland.get_cell_item(tile_target) == 6:
						farmland.set_cell_item(tile_target, 1)
				2: # Hoe
					if farmland.get_cell_item(tile_target) == 1:
						farmland.set_cell_item(tile_target, 3)
						farmland.set_cell_item(tile_target + Vector3i.UP, 4)
						plants[tile_target] = 0.0
				3: # Collector
					if farmland.get_cell_item(tile_target + Vector3i.UP) == 5:
						farmland.set_cell_item(tile_target + Vector3i.UP, -1) 
						farmland.set_cell_item(tile_target, 1) 
						plants.erase(tile_target)
	
	for p in plants.keys():
		if plants.get(p) > PLANT_TIME * 3:
			farmland.set_cell_item(p + Vector3i.UP, -1)
			farmland.set_cell_item(p, 6)
		else:
			if plants.get(p) > PLANT_TIME:
				farmland.set_cell_item(p + Vector3i.UP, 5)
			plants[p] += delta
			#grow the plant 
			
	
	

func toggle_pause():
	visible = !is_processing()
	uilayer.visible = !is_processing()
	set_process(!is_processing())
