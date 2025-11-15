class_name AnyMainMenu extends SwappableMenu

signal sig_minigame

@onready var minigame: Button = $VBoxContainer/Minigame

@export var is_minigame:=false
@export var title: String
@export var options_button:Button
@export var options_menu:SwappableMenu
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if options_menu==null:
		options_button.hide()
	else:
		options_button.show()
	if is_minigame:
		minigame.hide()
	else:
		minigame.show()

func _on_options_pressed() -> void:
	self.sig_swap.emit(options_menu,true)


func _on_exit_pressed() -> void:
	self.sig_close.emit()


func _on_minigame_pressed() -> void:
	sig_minigame.emit()


func _on_play_pressed() -> void:
	sig_play.emit()
