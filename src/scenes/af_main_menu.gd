class_name AsteroidFarmingMainMenu extends SwappableMenu

@export var is_minigame:=false
@export var title: String
@export var options_button:Button
@export var options_menu:SwappableMenu
@export var leaderboard_menu:SwappableMenu
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if options_menu==null:
		options_button.hide()
	else:
		options_button.show()

func enter()->void:
	self.show()

func _on_options_pressed() -> void:
	self.sig_swap.emit(options_menu,true)


func _on_exit_pressed() -> void:
	self.sig_close.emit()


func _on_play_pressed() -> void:
	sig_play.emit()


func _on_leaderboard_pressed() -> void:
	self.sig_swap.emit(leaderboard_menu,true)
