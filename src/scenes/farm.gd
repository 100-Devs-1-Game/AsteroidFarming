class_name Farm extends GridMap

var cur_coords:=Vector3i.UP*9001
var cur_stored:bool=false
var _element_dict:Dictionary[int,FarmElement]
var tool:FarmConstants.TOOL=FarmConstants.TOOL.NOTHING
@onready var select_timer: Timer = $"Select Timer"
@onready var cycle_timer: Timer = $"Cycle Timer"

@export var true_gridmap:GridMap
signal sig_harvested
signal sig_lost(count:int)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not true_gridmap:
		true_gridmap=$TrueGridMap
	assert(true_gridmap)
	true_gridmap.hide()
	_internal_setup()


func choose_tool(ind:int):
	self.tool=ind

func setup(data:Dictionary={}) -> void:
	select_timer.wait_time=data.get('select_time',select_timer.wait_time)
	cycle_timer.wait_time=data.get('cycle_time',cycle_timer.wait_time)

func _internal_setup():
	self.clear()
	for coords in true_gridmap.get_used_cells():
		var value:=true_gridmap.get_cell_item(coords)
		var orientation:=true_gridmap.get_cell_item_orientation(coords)
		self.set_cell_item(coords,value,orientation)
	for child in self.get_children():
		if is_instance_of(child,FarmElement):
			var el:FarmElement=child
			var el_type:=el.el_type
			self._element_dict[el.el_type]=el
	return
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("change_tool"):
		tool+=1
		tool%=FarmConstants.TOOL.size()
	pass

func interact(position:Vector3,click:bool):
	var cell_coords:=self.local_to_map(self.to_local(position))
	var cell_value:=true_gridmap.get_cell_item(cell_coords)
	if click:
		var change=determine_change(cur_coords)
		self.true_gridmap.set_cell_item(cur_coords,change)
		if cell_value==FarmConstants.TILE.END_WHEAT:
			sig_harvested.emit()
		toggle_hide()
		toggle_hide()
	else:
		if cur_stored and cell_coords!=cur_coords:
			toggle_hide()
			cur_coords=cell_coords
			toggle_hide()
		cur_coords=cell_coords

func toggle_hide():
	var change:int=-1
	if cur_stored:
		change=true_gridmap.get_cell_item(cur_coords)
	else:
		change=determine_change(cur_coords)
	self.set_cell_item(cur_coords,change)
	cur_stored=not cur_stored

func determine_change(cell:Vector3i)->int:
	var cur:=true_gridmap.get_cell_item(cell)
	if cur not in self._element_dict:
		return cur
	var element:FarmElement=self._element_dict.get(cur)
	var res:int=element.manual_change(self.tool)
	return res

func get_neighbours(cell:Vector3i,exclude_self:bool=true)->Dictionary[FarmConstants.TILE,int]:
	var cells:Dictionary[Vector2i,int]={}
	for i in range(-1,2):
		for j in range(-1,2):
			cells[Vector2i(i,j)]=self.get_cell_item(Vector3i(i,0,j))
	if exclude_self:
		cells.erase(Vector2i.ZERO)
	var res:Dictionary[FarmConstants.TILE,int]
	for key in cells:
		var value:=cells[key]
		if value not in range(FarmConstants.TILE.size()):
			continue
		res.get_or_add(value,0)
		res[value]+=1
	return res

func determine_autochange(cell:Vector3i)->int:
	var cur:=true_gridmap.get_cell_item(cell)
	if cur not in self._element_dict:
		return cur
	var element:FarmElement=self._element_dict.get(cur)
	var neigh:=self.get_neighbours(cell)
	var res:int=element.auto_change(neigh,element.transitions)
	if res==cur:
		return cur # for debugging purposes
	return res

func set_cell_res(cell:Vector3i,res:int):
	true_gridmap.set_cell_item(cell,res)
	if cell==cur_coords:
		cur_stored=false
	self.set_cell_item(cell,res)

func run_cycle():
	var new_ones:Dictionary[Vector3i,int]
	for cell in self.get_used_cells():
		var old:=self.get_cell_item(cell)
		var size:=FarmConstants.TILE.size() 
		var new:int
		# new=(abs(cell.x)+abs(cell.y))%size
		new=self.determine_autochange(cell)
		if new!=old:
			new_ones[cell]=new
	if not new_ones:
		return
	var lost:=0
	for cell in new_ones:
		var new:=new_ones[cell]
		self.set_cell_res(cell,new)
		if new==FarmConstants.TILE.VIRUS:
			lost+=1
	if lost:
		sig_lost.emit(lost)
