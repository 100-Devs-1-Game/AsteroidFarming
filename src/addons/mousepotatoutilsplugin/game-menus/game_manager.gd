class_name GameManager extends MenuManager

@export var minigame_test:MenuManager
@export var result_menu:SwappableMenu

func open_minigame_menu():
	assert(minigame_test)
	self.open(minigame_test,true)


func end_game(data: Dictionary={}) -> void:
	exported_data.merge(data,true)
	quick_menu.close()
	if "result" in data:
		assert(result_menu)
		self.manage_open(result_menu,true)
	print_debug(data)
	self.game.queue_free()
