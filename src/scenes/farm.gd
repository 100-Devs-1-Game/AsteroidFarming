class_name Farm extends GridMap


var cur_coords:=Vector3i.UP*9001
var cur_stored:=-1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact(position:Vector3,click:bool):
	var cell_coords:=self.local_to_map(self.to_local(position))
	var cell_value:=self.get_cell_item(cell_coords)
	if click:
		pass
	else:
		if cur_stored!=-1 and cell_coords!=cur_coords:
			toggle_hide()
			cur_coords=cell_coords
			toggle_hide()
		cur_coords=cell_coords

func toggle_hide():
	if cur_stored==-1:
		cur_stored=self.get_cell_item(cur_coords)
		self.set_cell_item(cur_coords,-1)
		return
	self.set_cell_item(cur_coords,cur_stored)
	cur_stored=-1
