@tool
class_name MpupUiDictElement extends HBoxContainer

signal sig_updated(key:String, value:String)
@export var name_node: TextEdit
@export var value_node: TextEdit
@export_category("Parameters")
@export var name_width:float=200
@export var data_width:float=200
@export var height:float=50

func _process(_delta: float) -> void:
	pass

func onresize():
	if name_node==null or value_node==null:
		return
	name_node.custom_minimum_size.x=name_width
	name_node.custom_minimum_size.y=height
	value_node.custom_minimum_size.x=data_width
	

func setup(key:String, value:String):
	name_node.text=key
	value_node.text=value
	self.show()
	return
