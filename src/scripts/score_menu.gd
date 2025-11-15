class_name ScoreMenu extends SwappableMenu

@onready var display: DisplayScore = $RichTextLabel

func enter(new_data:Dictionary)->void:
	self.display.display_score(new_data.get("result",{}))
	self.show()
