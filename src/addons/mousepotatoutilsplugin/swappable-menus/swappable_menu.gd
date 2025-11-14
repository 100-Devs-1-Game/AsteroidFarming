class_name SwappableMenu extends Control

var exported_data:Dictionary

@export var scene_parent:Node
signal sig_swap(new_menu:SwappableMenu,stack_up:bool)
signal sig_open_raw(new_menu:String,stack_up:bool)
signal sig_close

signal sig_setup
signal sig_play

func enter()->void:
	self.show()

func exit()->void:
	self.hide()

func open_raw(new_menu:String,stack_up:bool=false):
	sig_open_raw.emit(new_menu,stack_up)

func open(new_menu:SwappableMenu,stack_up:bool=false):
	sig_swap.emit(new_menu,stack_up)

func close()->void:
	sig_close.emit()
	hide()

func exit_game()->void:
	get_tree().quit()
