class_name MpupUiDictEdit extends Control

@export var keys_display:MpupUiButtonList
@export var key_edit:TextEdit
@export var value_edit:TextEdit
@export var do_auto_update:CheckButton
@export var do_move_value:CheckButton
@export_category("Variables")
@export var min_button_size:float=200

@export var debug:bool=true

var _dict:Dictionary[String,String]

var old_key:String=""
signal clicked(name:bool)
signal sig_updated
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	return

func testprint(test: String) -> void:
	print_debug(test)

func set_names():
	var namedict:Dictionary[String,String]={}
	for key in self._dict.keys():
		namedict[key]=key+": "+self._dict[key]
	self.keys_display.set_elements(namedict)
	sig_updated.emit()

func set_elements(dict: Dictionary):
	self._dict=dict
	self.set_names()

func read(key:String):
	var value:=self._dict[key]
	self.key_edit.text=key
	self.value_edit.text=value
	self.old_key=key

func auto_update():
	if do_auto_update.button_pressed:
		update()

func update():
	var key:=self.key_edit.text
	var value:=self.value_edit.text
	if self.do_move_value.button_pressed and self.old_key in self._dict and self.old_key!=key:
		self._dict.erase(self.old_key)
	self._dict[key]=value
	self.old_key=key
	self.set_names()

func remove():
	var key:=self.key_edit.text
	var value:=self.value_edit.text
	if self.do_move_value and self.old_key in self._dict and self.old_key!=key:
		self._dict.erase(self.old_key)
	self._dict.erase(key)
	self.old_key=key
	self.set_names()
