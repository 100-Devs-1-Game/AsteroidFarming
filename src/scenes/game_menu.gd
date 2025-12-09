class_name AsteroidFarmingQuickMenu extends Control

signal sig_interact
signal sig_end_game
signal sig_exit_to_menu

signal sig_choose_tool(ind: int)
@export var score_node: DisplayScore



func interact_with_game():
	sig_interact.emit()


func _on_end_game_pressed() -> void:
	sig_end_game.emit()


func _on_exit_to_menu_pressed() -> void:
	sig_exit_to_menu.emit()


func _on_exit_to_desktop_pressed() -> void:
	get_tree().quit()

func display_score(score_data:Dictionary):
	score_node.display_score(score_data)


func _on_tools_item_selected(index: int) -> void:
	sig_choose_tool.emit(index)
