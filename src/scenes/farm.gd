class_name Farm extends GridMap

var cur_coords:=Vector3i.UP*9001
var cur_stored:bool=false
var _element_dict:Dictionary[int,FarmElement]
var tool:int=-1

@export var true_gridmap:GridMap
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not true_gridmap:
		true_gridmap=$TrueGridMap
	assert(true_gridmap)
	true_gridmap.hide()
	self.clear()
	for coords in true_gridmap.get_used_cells():
		var value:=true_gridmap.get_cell_item(coords)
		var orientation:=true_gridmap.get_cell_item_orientation(coords)
		self.set_cell_item(coords,value,orientation)
	for child in self.get_children():
		if is_instance_of(child,FarmElement):
			var el:FarmElement=child
			self._element_dict[el.type]=el


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact(position:Vector3,click:bool):
	var cell_coords:=self.local_to_map(self.to_local(position))
	var cell_value:=true_gridmap.get_cell_item(cell_coords)
	if click:
		var change=determine_change(cur_coords)
		self.true_gridmap.set_cell_item(cur_coords,change)
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
	var res:int=element.manual_change(FarmConstants.TOOL.NOTHING)
	print(cur,res)
	return res
