class_name ScoreMenu extends SwappableMenu

@export var display: DisplayScore
@export var name_input: TextEdit

func enter(new_data:Dictionary)->void:
	self.display.display_score(new_data.get("result",{}))
	self.show()


func submit_to_leaderboard() -> void:
	var name:String=name_input.text
