class_name Minigame extends Node

signal sig_start
signal sig_end(data:Dictionary)

@export var control:VariousControl

func setup_game(data:Dictionary={}):
	push_error("Minigame %s setup not implemented!" % [self.name])

func start_game(data:Dictionary={}):
	push_error("Minigame %s start not implemented!" % [self.name])

func end_game()->void:
	push_error("Minigame %s end not implemented!" % [self.name])
	sig_end.emit({"error":"Minigame %s end not implemented!"})
