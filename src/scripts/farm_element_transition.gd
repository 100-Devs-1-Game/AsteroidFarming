class_name FarmElementTransition extends Node3D

@export var target:FarmConstants.TILE
@export var base:float
@export var modifiers:Dictionary[FarmConstants.TILE,float]

func decide(start:FarmConstants.TILE,relevant_elements:Dictionary[FarmConstants.TILE,int]):
	var odds:=base
	for type in relevant_elements:
		var count:=relevant_elements[type]
		var modifier:float=modifiers.get(type,0.0)
		modifier*=count
		odds+=modifier
	var decision:=randf()
	if decision<odds:
		return self.target
	return base
