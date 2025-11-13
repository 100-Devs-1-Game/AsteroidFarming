class_name FarmElement extends Node3D

@export var type:FarmConstants.TILE
@export var next_element:FarmConstants.TILE
@export var next_element_factors:Dictionary[FarmConstants.TILE,float]
@export var transitions:Array[FarmElementTransition]
@export var default_tool_transition:FarmConstants.TILE

func _ready() -> void:
	return

func manual_change(tool:FarmConstants.TOOL):
	return default_tool_transition

func auto_change(relevant_elements:Dictionary[FarmConstants.TILE,int])->FarmConstants.TILE:
	var res:=self.type
	for transition in self.transitions:
		res=transition.decide(res,relevant_elements)
		if res!=self.type:
			break
	return res
