extends Node3D

@onready var cam: Camera3D = $"camera pivot/cam"
@onready var farmland: GridMap = $Farmland
@onready var overlay: MeshInstance3D = $Farmland/overlay

var active_tool = 0
const TargetPlane = Plane.PLANE_XZ

@onready var uilayer: CanvasLayer = $CanvasLayer
@onready var game_menu: Control = $"CanvasLayer/Game Menu"

const PLANT_TIME = 6.0
var DECAYTIME = 20.0
var plants: Dictionary[Vector3i, float] = {}

enum TOOLS {
	Bucket = 0,
	Shovel = 1,
	Hoe = 2,
	Collector = 3
}
enum BLOCKS {
	Stone = 0,
	Dirt = 1,
	Water = 2,
	Soil = 3,
	WheatStart = 4,
	WheatEnd = 5,
	Virus = 6
}

func _unhandled_input(_event: InputEvent) -> void:
	#Step 1, get target tile. 
	var tile_target = null
	var mousepos = get_viewport().get_mouse_position()
	var result = TargetPlane.intersects_ray(cam.project_ray_origin(mousepos), cam.project_ray_normal(mousepos))
	if result:
		result += Vector3.DOWN / 2
		tile_target = farmland.local_to_map(farmland.to_local(result))
		#Step 2, apply tool effect to target tile
	if tile_target and farmland.get_used_cells().has(tile_target):
		var highlight = tile_target
		if plants.has(tile_target):
			highlight += Vector3i.UP
		overlay.position = farmland.map_to_local(highlight)
	if Input.is_action_just_pressed("click"):
		if farmland.get_used_cells().has(tile_target):
			match active_tool:
				0: # Bucket
					if farmland.get_cell_item(tile_target) == BLOCKS.Dirt or farmland.get_cell_item(tile_target) == BLOCKS.Soil:
						farmland.set_cell_item(tile_target, BLOCKS.Water)
						for side in [Vector3i.LEFT, Vector3i.FORWARD, Vector3i.RIGHT, Vector3i.BACK]:
							if farmland.get_cell_item(tile_target + side) == BLOCKS.Dirt:
								farmland.set_cell_item(tile_target + side, BLOCKS.Soil)
					elif farmland.get_cell_item(tile_target) == BLOCKS.Water:
						farmland.set_cell_item(tile_target, BLOCKS.Dirt)
						for side in [Vector3i.LEFT, Vector3i.FORWARD, Vector3i.RIGHT, Vector3i.BACK]:
							if farmland.get_cell_item(tile_target + side) == BLOCKS.Soil:
								farmland.set_cell_item(tile_target + side, BLOCKS.Dirt)
				1:  # Shovel
					if farmland.get_cell_item(tile_target) == BLOCKS.Virus:
						farmland.set_cell_item(tile_target, BLOCKS.Dirt)
				2: # Hoe
					if farmland.get_cell_item(tile_target) == BLOCKS.Soil:
						farmland.set_cell_item(tile_target + Vector3i.UP, BLOCKS.WheatStart)
						plants[tile_target] = 0.0
				3: # Collector
					if farmland.get_cell_item(tile_target + Vector3i.UP) == BLOCKS.WheatEnd:
						farmland.set_cell_item(tile_target + Vector3i.UP, -1) 
						farmland.set_cell_item(tile_target, BLOCKS.Dirt) 
						plants.erase(tile_target)
						game_menu.score += 1
						game_menu.harvested += 1
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("change_tool"):
		active_tool = wrapi(active_tool + 1, 0, 4)
	
	var cleanup = []
	for p in plants.keys():
		if plants.get(p) > DECAYTIME:
			farmland.set_cell_item(p, BLOCKS.Virus)
			farmland.set_cell_item(p + Vector3i.UP, -1)
			cleanup.append(p)
			DECAYTIME = 20 + (randf() * 5)
		elif plants.get(p) > PLANT_TIME:
			if !farmland.get_cell_item(p + Vector3i.UP) == BLOCKS.WheatEnd:
				farmland.set_cell_item(p + Vector3i.UP, BLOCKS.WheatEnd)
		plants[p] += delta 
			#grow the plant 
			
	for c in cleanup:
		plants.erase(c)
	

func toggle_pause():
	visible = !is_processing()
	uilayer.visible = !is_processing()
	set_process(!is_processing())
