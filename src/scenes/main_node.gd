extends Minigame

@onready var main_scene: AsteroidFarmingMainScene = $"Main Scene"

var score:=0
var harvested:=0
var lost:=0
var harvest_value:=1
var virus_penalty:=1
var deadline:=-1

signal sig_change_value(value:Dictionary)

func pass_mouse_input():
	main_scene.pass_mouse_input()

func choose_tool(ind:int):
	main_scene.choose_tool(ind)

func setup_game(data:Dictionary={}):
	var grid_data:Dictionary=data.get("farm",{})
	
	push_error("Minigame %s setup not implemented!" % [self.name])

func start_game(data:Dictionary={}):
	var ret_dict:=generate_ret_dict()
	sig_change_value.emit(ret_dict)

func generate_ret_dict()->Dictionary:
	var ret_dict:={
		"score":self.score,
		"harvested":self.harvested,
		"lost":self.lost
	}
	return ret_dict

func end_game()->void:
	var ret_dict:=generate_ret_dict()
	sig_end.emit({"result":ret_dict})

func exit_to_menu()->void:
	sig_end.emit({})

func _on_grid_map_sig_harvested() -> void:
	self.harvested+=1
	self.score+=harvest_value
	var ret_dict:=generate_ret_dict()
	sig_change_value.emit(ret_dict)
	


func _on_grid_map_sig_lost(count: int) -> void:
	self.lost+=count
	self.score-=virus_penalty*count
	var ret_dict:=generate_ret_dict()
	sig_change_value.emit(ret_dict)
