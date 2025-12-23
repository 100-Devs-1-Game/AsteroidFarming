class_name GameMenu
extends Control

@onready var main_menu: Control = get_tree().current_scene.get_node("Main Menu")
@onready var score_label: Label = %Score
@onready var harvest_count_label: Label = %Harvest_count
@onready var lost_count_label: Label = %Lost_count
@onready var credits_label: Label = %Credits
@onready var seeds_label: Label = %Seeds

@onready var tool_buttons = {
	0: %tool_bucket,
	1: %tool_shovel, 
	2: %tool_hoe,
	3: %tool_collector
}

var score: int = 0:
	set(value):
		score = value
		score_label.text = "Score: " + str(value)
var harvested: int = 0:
	set(value):
		harvested = value
		harvest_count_label.text = "Harvested: " + str(value)
var lost: int = 0:
	set(value):
		lost = value
		lost_count_label.text = "Lost: " + str(value)
var credits: int = 0:
	set(value):
		credits= value
		credits_label.text= "Credits: " + str(credits)
		EventManager.credits_updated.emit(credits)
var seeds: int = 0:
	set(value):
		seeds= value
		seeds_label.text= "Seeds: " + str(seeds)
		EventManager.seeds_updated.emit(seeds)

var tool: int: 
	set(value): owner.active_tool = value
	get(): return owner.active_tool


func _ready() -> void:
	score = 0
	harvested = 0
	lost = 0
	credits = 0
	seeds = 5
	_on_h_slider_value_changed(0.5)
	EventManager.bought_seeds.connect(func(amount: int):
		seeds+= amount
		credits-= amount * Shop.SEED_PRICE
		harvested= 0
	)

func _process(_delta: float) -> void:
	for b in tool_buttons.keys():
		if b == tool:
			tool_buttons.get(b).modulate = Color(1.0, 1.0, 1.0, 1.0)
		else:
			tool_buttons.get(b).modulate = Color(0.202, 0.202, 0.202, 1.0)

func _on_end_game_button_down() -> void:
	pass # Replace with function body.

func _on_exit_to_menu_button_down() -> void:
	get_parent().hide()
	owner.hide()
	main_menu.show()

func _on_exit_to_desktop_button_down() -> void:
	get_tree().quit()

func _on_tool_bucket_button_down() -> void:
	owner.active_tool = 0

func _on_tool_shovel_button_down() -> void:
	owner.active_tool = 1

func _on_tool_hoe_button_down() -> void:
	owner.active_tool = 2

func _on_tool_collector_button_down() -> void:
	owner.active_tool = 3


func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, linear_to_db(value))
