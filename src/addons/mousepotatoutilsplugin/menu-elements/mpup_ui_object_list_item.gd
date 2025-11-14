@tool
class_name MpupUiObjectListItem extends Control

signal sig_updated

signal sig_button_pressed
signal sig_interact(key:String,value:String)

func setup(values: Dictionary):
	return

func on_interact(key:String,value:String):
	sig_interact.emit(key,value)

func on_update():
	sig_updated.emit()


func on_button_press() -> void:
	sig_button_pressed.emit()
