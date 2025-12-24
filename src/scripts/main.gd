extends Node3D

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

const SIDES = [Vector3i.LEFT, Vector3i.FORWARD, Vector3i.RIGHT, Vector3i.BACK]
const TargetPlane = Plane.PLANE_XZ
const PLANT_TIME = 12.0
var DECAYTIME = 20.0
const VIRUS_SPREAD_CHANCE = 10.0

@onready var cam: Camera3D = $"camera pivot/cam"
@onready var farmland: GridMap = $Farmland
@onready var overlay: MeshInstance3D = $Farmland/overlay
@onready var uilayer: CanvasLayer = $CanvasLayer
@onready var game_menu: GameMenu = $"CanvasLayer/Game Menu"
@onready var spaceship: Node3D = %Spaceship
@onready var spaceship_spawn: Marker3D = %"Spaceship Spawn"
@onready var spaceship_despawn: Marker3D = %"Spaceship Despawn"
@onready var spaceship_docking: Marker3D = %"Spaceship Docking"
@onready var spaceship_cooldown: Timer = %"Spaceship Cooldown"
@onready var shop: Shop = $CanvasLayer/ShopUI
@onready var audio_player_spaceship: AudioStreamPlayer3D = %"AudioStreamPlayer3D Spaceship"

var plants: Dictionary[Vector3i, float] = {}
var active_tool: TOOLS = TOOLS.Bucket:
	set(t):
		if active_tool == t: return
		active_tool = t
		%"AudioStreamPlayer Equip".play()
		
var spaceship_tween: Tween
var taxes := 1

func _ready() -> void:
	EventManager.sell_harvest.connect(func():
		var harvested := game_menu.harvested 
		game_menu.credits += harvested
		game_menu.harvested = 0
		EventManager.sold_harvest.emit(harvested)
	)
	EventManager.pay_taxes.connect(func():
		game_menu.credits -= taxes
		if game_menu.credits < 0:
			game_over()
		EventManager.update_taxes.emit(taxes)
		taxes += 1
	)


func _unhandled_input(_event: InputEvent) -> void:
	#Step 1, get target tile. 
	var tile_target = null
	var mousepos = get_viewport().get_mouse_position()
	var result = TargetPlane.intersects_ray(cam.project_ray_origin(mousepos), cam.project_ray_normal(mousepos))
	var target_item = -1
	if result != null:
		result += Vector3.DOWN / 2
		tile_target = farmland.local_to_map(farmland.to_local(result))
		#Step 2, apply tool effect to target tile
	if tile_target != null and farmland.get_used_cells().has(tile_target):
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
				if target_item == BLOCKS.Soil and !plants.has(tile_target) and game_menu.seeds > 0:
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
						%"AudioStreamPlayer Splash".play()
					elif target_item == BLOCKS.Water:
						farmland.set_cell_item(tile_target, BLOCKS.Dirt)
						for side in SIDES:
							if farmland.get_cell_item(tile_target + side) == BLOCKS.Soil:
								farmland.set_cell_item(tile_target + side, BLOCKS.Dirt)
						%"AudioStreamPlayer Suck".play()
				TOOLS.Shovel:  # Shovel
					if target_item == BLOCKS.Virus:
						farmland.set_cell_item(tile_target, BLOCKS.Dirt)
						%"AudioStreamPlayer Shovel".play()
				TOOLS.Hoe: # Hoe
					if target_item == BLOCKS.Soil and !plants.has(tile_target) and game_menu.seeds > 0:
						farmland.set_cell_item(tile_target + Vector3i.UP, BLOCKS.WheatStart)
						plants[tile_target] = 0.0
						game_menu.seeds -= 1
						%"AudioStreamPlayer Drop".play()
				TOOLS.Collector: # Collector
					if farmland.get_cell_item(tile_target + Vector3i.UP) == BLOCKS.WheatEnd:
						farmland.set_cell_item(tile_target + Vector3i.UP, -1) 
						farmland.set_cell_item(tile_target, BLOCKS.Dirt) 
						plants.erase(tile_target)
						game_menu.score += 1
						game_menu.harvested += 1
						game_menu.seeds += 1
						%"AudioStreamPlayer Cut".play()

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


func game_over():
	get_tree().change_scene_to_packed(load("uid://btagksi1j8xfe"))


func _on_spaceship_cooldown_timeout() -> void:
	spaceship.position = spaceship_spawn.position
	spaceship.show()
	spaceship_tween= create_tween()
	spaceship_tween.tween_property(spaceship, "position", spaceship_docking.position, 5.0).set_ease(Tween.EASE_OUT)
	spaceship_tween.tween_callback(func():
		shop.open()
		audio_player_spaceship.stop()
	)
	audio_player_spaceship.play()


func _on_shop_ui_closed() -> void:
	spaceship_cooldown.wait_time += 5
	spaceship_tween= create_tween()
	spaceship_tween.tween_property(spaceship, "position", spaceship_despawn.position, 10.0).set_ease(Tween.EASE_IN)
	spaceship_tween.tween_callback(spaceship_cooldown.start)
	audio_player_spaceship.play()
