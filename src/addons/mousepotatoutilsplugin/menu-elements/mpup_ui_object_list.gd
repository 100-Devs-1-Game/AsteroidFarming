@tool
class_name MpupUiObjectList extends BoxContainer

enum SORTMETHOD {
	NONE,
	NAME
}

enum DIRECTION {
	ASCENDING,
	DESCENDING
}

@export var element:MpupUiObjectListItem
@export var debug:bool=true
@export_category("Options")
@export var sort_method:SORTMETHOD=SORTMETHOD.NONE
@export var order:DIRECTION=DIRECTION.ASCENDING

signal clicked(name:bool)
signal instruction_made(data:Dictionary)


func clear_elements():
	for child in self.get_children():
		child.queue_free()

func setup_element(_object:MpupUiObjectListItem):
	return

func setup(names:Dictionary[String,Dictionary],delete_old:bool=true) -> void:
	if not self.element:
		push_error("VerticalObjectList missing element!")
		return
	if delete_old:
		clear_elements()
	var name_keys:Array=names.keys()
	if self.sort_method==SORTMETHOD.NAME:
		name_keys.sort()
		if self.order==DIRECTION.DESCENDING:
			name_keys.reverse()
	for name in name_keys:
		var disp_data:Dictionary=names[name]
		var element:MpupUiObjectListItem=self.element.duplicate()
		element.name=name
		element.custom_minimum_size.x=self.size.x
		element.setup(disp_data)
		# TODO add element change/button signal
		self.add_child(element)
		setup_element(element)
		element.show()
		print(element.size)
		element.sig_button_pressed.connect(on_button_press.bind(name,element))
	return


func on_button_press(key:String, item:MpupUiButtonList):
	return
