class_name FarmElement extends Node3D

@export var el_type:FarmConstants.TILE
@export var transitions:Array[FarmElementTransition]
@export var new_transition:FarmElementTransition=null
@export var default_tool_transition:FarmConstants.TILE
@export var tool_transitions:Dictionary[FarmConstants.TOOL,FarmConstants.TILE]

func manual_change(tool:FarmConstants.TOOL):
	var next:FarmConstants.TILE=self.tool_transitions.get(tool,default_tool_transition)
	return next

func auto_change(relevant_elements:Dictionary[FarmConstants.TILE,int],test=null)->FarmConstants.TILE:
	var res:=self.el_type
	assert(transitions == test)
	for transition in self.transitions:
		if transition==null:
			continue
		res=transition.decide(res,relevant_elements)
		if res!=self.el_type:
			break
	return res
