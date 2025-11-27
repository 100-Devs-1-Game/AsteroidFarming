class_name FarmElement extends Node3D

@export var el_type:FarmConstants.TILE
@export var transitions:Array[FarmElementTransition]
@export var new_transition:FarmElementTransition=null
@export var default_tool_transition:FarmConstants.TILE
@export var tool_transitions:Dictionary[FarmConstants.TOOL,FarmConstants.TILE]

@export var tool_sounds:Dictionary[FarmConstants.TOOL,String]
@export var default_tool_sound:String="none"
@export var default_wrong_tool_sound:String="wrong"
var last_sound:String="none"

func manual_change(tool:FarmConstants.TOOL):
	var next:FarmConstants.TILE=self.tool_transitions.get(tool,default_tool_transition)
	return next

func manual_sound(tool:FarmConstants.TOOL)->String:
	var is_good:=tool in tool_transitions
	var default_sound:=default_tool_sound if is_good else default_wrong_tool_sound
	var cur_sound:String=tool_sounds.get(tool,default_sound)
	return cur_sound

func auto_change(relevant_elements:Dictionary[FarmConstants.TILE,int],test=null)->FarmConstants.TILE:
	var res:=self.el_type
	assert(transitions == test)
	last_sound="none"
	for transition in self.transitions:
		if transition==null:
			continue
		res=transition.decide(res,relevant_elements)
		if res!=self.el_type:
			last_sound=transition.sound
			break
	return res
	
