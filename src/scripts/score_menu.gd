class_name ScoreMenu extends SwappableMenu

@export var display: DisplayScore

func enter(new_data:Dictionary)->void:
	self.display.display_score(new_data.get("result",{}))
	self.show()
