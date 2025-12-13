extends Node3D

const SIDES = [Vector3i.LEFT, Vector3i.FORWARD, Vector3i.RIGHT, Vector3i.BACK]

@onready var cam: Camera3D = $"camera pivot/cam"
@onready var farmland: GridMap = $Farmland
@onready var overlay: MeshInstance3D = $Farmland/overlay

const TargetPlane = Plane.PLANE_XZ

@onready var uilayer: CanvasLayer = $CanvasLayer
@onready var game_menu: Control = $"CanvasLayer/Game Menu"

const PLANT_TIME = 6.0
const VIRUS_SPREAD_CHANCE = 10.0
var DECAYTIME = 20.0
var plants: Dictionary[Vector3i, float] = {}

enum TOOLS {
	Bucket = 0,
	Shovel = 1,
	Hoe = 2,
	Collector = 3
}
var active_tool: TOOLS = TOOLS.Bucket
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
	var target_item = -1
	if result:
		result += Vector3.DOWN / 2
		tile_target = farmland.local_to_map(farmland.to_local(result))
		#Step 2, apply tool effect to target tile
	if tile_target and farmland.get_used_cells().has(tile_target):
		var highlight = tile_target
		overlay.mesh.size.y = 1.15
		if plants.has(tile_target):
			highlight += Vector3i.UP
			if plants.get(tile_target) > PLANT_TIME:
				overlay.mesh.size.y = 2.15
		overlay.position = farmland.map_to_local(highlight)
		
		var color = Color.RED
		target_item = farmland.get_cell_item(tile_target)
		
		match active_tool:
			TOOLS.Bucket:
				if target_item == BLOCKS.Dirt or target_item == BLOCKS.Soil or target_item == BLOCKS.Water:
					color = Color.GREEN
			TOOLS.Shovel:
				if target_item == BLOCKS.Virus:
					color = Color.GREEN
			TOOLS.Hoe:
				if target_item == BLOCKS.Soil and !plants.has(tile_target):
					color = Color.GREEN
			TOOLS.Collector:
				if plants.has(tile_target) and plants.get(tile_target) > PLANT_TIME:
					color = Color.GREEN
		color.a = 0.2
		overlay.mesh.surface_get_material(0).set("albedo_color", color)
		
	if Input.is_action_just_pressed("click"):
		if farmland.get_used_cells().has(tile_target) and target_item != -1:
			match active_tool:
				TOOLS.Bucket: # Bucket
					if target_item == BLOCKS.Dirt or target_item == BLOCKS.Soil:
						farmland.set_cell_item(tile_target, BLOCKS.Water)
						for side in SIDES:
							if farmland.get_cell_item(tile_target + side) == BLOCKS.Dirt:
								farmland.set_cell_item(tile_target + side, BLOCKS.Soil)
					elif target_item == BLOCKS.Water:
						farmland.set_cell_item(tile_target, BLOCKS.Dirt)
						for side in SIDES:
							if farmland.get_cell_item(tile_target + side) == BLOCKS.Soil:
								farmland.set_cell_item(tile_target + side, BLOCKS.Dirt)
				TOOLS.Shovel:  # Shovel
					if target_item == BLOCKS.Virus:
						farmland.set_cell_item(tile_target, BLOCKS.Dirt)
				TOOLS.Hoe: # Hoe
					if target_item == BLOCKS.Soil and !plants.has(tile_target):
						farmland.set_cell_item(tile_target + Vector3i.UP, BLOCKS.WheatStart)
						plants[tile_target] = 0.0
				TOOLS.Collector: # Collector
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
			game_menu.lost += 1
		elif plants.get(p) > PLANT_TIME:
			if !farmland.get_cell_item(p + Vector3i.UP) == BLOCKS.WheatEnd:
				farmland.set_cell_item(p + Vector3i.UP, BLOCKS.WheatEnd)
		plants[p] += delta 
			#grow the plant 
			
	for c in cleanup:
		plants.erase(c)


func _physics_process(_delta: float) -> void:
	var rnd_pos: Vector3i = farmland.get_used_cells().pick_random()
	var block := farmland.get_cell_item(rnd_pos)
	match block:
		BLOCKS.Virus:
			if randf() * 100 > VIRUS_SPREAD_CHANCE:
				return 
			var side: Vector3i = SIDES.pick_random()
			var neighbor := rnd_pos + side
			if farmland.get_cell_item(neighbor) == BLOCKS.Dirt:
				farmland.set_cell_item(neighbor, BLOCKS.Virus)
				var above:= neighbor + Vector3i.UP
				if farmland.get_cell_item(above):
					farmland.set_cell_item(above, -1)
					game_menu.lost += 1
					plants.erase(above)


func toggle_pause():
	visible = !is_processing()
	uilayer.visible = !is_processing()
	set_process(!is_processing())
