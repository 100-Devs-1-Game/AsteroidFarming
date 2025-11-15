class_name FarmElementTransition extends Node3D

@export var target:FarmConstants.TILE
@export var base:float
@export var cap:float=1.0
@export var modifiers:Dictionary[FarmConstants.TILE,float]

func apply_modifier(el_type:FarmConstants.TILE,count:int)->float:
	var modifier:float=modifiers.get(el_type,0.0)
	modifier*=count
	return modifier
	

func decide(start:FarmConstants.TILE,relevant_elements:Dictionary[FarmConstants.TILE,int]):
	var odds:=base
	for el_type in relevant_elements:
		odds+=apply_modifier(el_type,relevant_elements[el_type])
	odds=min(odds,cap)
	var decision:=randf()
	if decision<odds:
		return self.target
	return start
