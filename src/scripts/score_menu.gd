class_name ScoreMenu extends SwappableMenu

@export var display: DisplayScore
@export var name_input: TextEdit
@export var leaderboard_menu: SwappableMenu

var result:Dictionary={}

func enter(new_data:Dictionary)->void:
	self.exported_data.merge(new_data,true)
	self.result=new_data.get_or_add("result",{})
	if not self.result.is_empty():
		new_data["last_result"]=self.result
	new_data.erase("result")
	self.display.display_score(result)
	self.show()

static func sort_by_score(el1:Dictionary,el2:Dictionary)->bool:
	var score1:int=el1.get("score",-1)
	var score2:int=el2.get("score",-1)
	if score1!=score2:
		return score1>score2
	return el1.get("name","???")>el2.get("name","???")

func submit_to_leaderboard() -> void:
	var name:String=name_input.text
	self.result["name"]=name
	if self.result.is_empty(): return
	if name.is_empty(): return
	var lead_size:int=self.exported_data.get("leaderboard_size",10)
	var leaderboard:Array=[]
	
	leaderboard=self.exported_data.get_or_add("leaderboard",leaderboard)
	leaderboard.append(self.result)
	leaderboard.sort_custom(sort_by_score)
	for el in leaderboard:
		print(el.get("name","???")+"\t\t"+str(el.get("score",-1)))
	if leaderboard_menu==null:
		close()
	else:
		open(leaderboard_menu)
