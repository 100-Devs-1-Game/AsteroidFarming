extends Control

@onready var main: Node3D = $"../Main"

func _on_play_button_down() -> void:
	hide()
	main.show()
	main.uilayer.show()
#
#func _on_options_button_down() -> void:
	#pass # Replace with function body.
#
#func _on_leaderboard_button_down() -> void:
	#pass # Replace with function body.

func _on_credits_button_down() -> void:
	pass # Replace with function body.

func _on_exit_button_down() -> void:
	pass # Replace with function body.

func _on_exit_all_button_down() -> void:
	pass # Replace with function body.
