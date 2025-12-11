extends Control

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

func _on_end_game_button_down() -> void:
	pass # Replace with function body.

func _on_exit_to_menu_button_down() -> void:
	get_parent().hide()
	owner.hide()

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
