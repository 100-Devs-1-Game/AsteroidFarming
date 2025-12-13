extends Control

@onready var main_menu: Control = $"../../../Main Menu"

@onready var tool_buttons = {
	0: $Hotbar/MarginContainer/VBoxContainer/tool_bucket,
	1: $Hotbar/MarginContainer/VBoxContainer/tool_shovel, 
	2: $Hotbar/MarginContainer/VBoxContainer/tool_hoe,
	3: $Hotbar/MarginContainer/VBoxContainer/tool_collector
}
var score: int = 0:
	set(value):
		score = value
		$Sidebar/MarginContainer/VBoxContainer/score.text = "Score: " + str(value)
var harvested: int = 0:
	set(value):
		harvested = value
		$Sidebar/MarginContainer/VBoxContainer/harvest_count.text = "Harvested: " + str(value)
var lost: int = 0:
	set(value):
		lost = value
		$Sidebar/MarginContainer/VBoxContainer/lost_count.text = "Lost: " + str(value)

var tool: int: 
	get(): return owner.active_tool
	set(value): owner.active_tool = value

func _ready() -> void:
	score = 0
	harvested = 0
	lost = 0
	_on_h_slider_value_changed(0.5)

func _process(_delta: float) -> void:
	for b in tool_buttons.keys():
		if b == tool:
			tool_buttons.get(b).modulate = Color(1.0, 1.0, 1.0, 1.0)
		else:
			tool_buttons.get(b).modulate = Color(0.202, 0.202, 0.202, 1.0)

func _on_end_game_button_down() -> void:
	pass # Replace with function body.

func _on_exit_to_menu_button_down() -> void:
	get_parent().hide()
	owner.hide()
	main_menu.show()

func _on_exit_to_desktop_button_down() -> void:
	get_tree().quit()

func _on_tool_bucket_button_down() -> void:
	owner.active_tool = 0

func _on_tool_shovel_button_down() -> void:
	owner.active_tool = 1

func _on_tool_hoe_button_down() -> void:
	owner.active_tool = 2

func _on_tool_collector_button_down() -> void:
	owner.active_tool = 3


func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, linear_to_db(value))
