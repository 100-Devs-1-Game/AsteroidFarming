@tool
class_name FarmElement extends Node3D

@export var type:FarmConstants.TILE
@export var transitions:Array[FarmElementTransition]
@export var new_transition:FarmElementTransition=null
@export var default_tool_transition:FarmConstants.TILE

func _process(_delta: float) -> void:
	var i:int=0
	if null in transitions:
		transitions.erase(null)
	if new_transition:
		transitions.append(new_transition)
		new_transition=null

func manual_change(tool:FarmConstants.TOOL):
	return default_tool_transition

func auto_change(relevant_elements:Dictionary[FarmConstants.TILE,int])->FarmConstants.TILE:
	var res:=self.type
	for transition in self.transitions:
		res=transition.decide(res,relevant_elements)
		if res!=self.type:
			break
	return res
