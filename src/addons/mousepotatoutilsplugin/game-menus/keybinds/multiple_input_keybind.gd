class_name MultipleInputKeybind extends MpupUiObjectListItem

@export var name_t: RichTextLabel
@export var existing: MpupUiButtonList
@export var new_role: Button

signal sig_remove_button(name:String)

func setup(values: Dictionary):
	self.name_t.name=values.get("action","ERROR")
	self.name_t.text=self.name_t.name
	var existing_bindings:Dictionary[String,String]=values.get("buttons",{})
	self.existing.set_elements(existing_bindings)
	toggle_adding(false)
	return


func toggle_adding(is_adding:bool):
	new_role.text="Press key" if is_adding else "Add new key"

func remove_button(name:String):
	self.existing.remove_element(name)
	sig_remove_button.emit(name)

func add_button(name:String,display_name:String)->bool:
	return self.existing.add_element(name,display_name)
