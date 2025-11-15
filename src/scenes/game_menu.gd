class_name AsteroidFarmingQuickMenu extends Control

signal sig_interact
signal sig_end_game
signal sig_exit_to_menu
@export var score_node: DisplayScore

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
