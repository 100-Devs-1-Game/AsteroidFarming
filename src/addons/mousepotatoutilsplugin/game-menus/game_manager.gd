class_name GameManager extends MenuManager

@export var minigame_test:MenuManager

func open_minigame_menu():
	assert(minigame_test)
	self.open(minigame_test,true)
