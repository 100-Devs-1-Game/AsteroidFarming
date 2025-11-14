class_name InputKeybind extends MpupUiObjectListItem

@export var name_t: RichTextLabel
@export var role: Button

func setup(values: Dictionary):
	if values.is_empty():
		values["ERROR"]="ERROR"
	name_t.text=values.keys()[0]
	role.text=values[name_t.text]
