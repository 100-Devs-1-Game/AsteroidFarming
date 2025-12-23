class_name Shop
extends PanelContainer

signal closed

const SEED_PRICE= 10

@onready var label_credits: Label = %"Label Credits"
@onready var label_seeds: Label = %"Label Seeds"
@onready var button_buy_1: Button = %"Button Buy1"
@onready var button_buy_5: Button = %"Button Buy5"
@onready var button_buy_10: Button = %"Button Buy10"
@onready var label_sold: Label = %Sold



func _ready() -> void:
	EventManager.credits_updated.connect(on_credits_updated)
	EventManager.seeds_updated.connect(on_seeds_updated)
	EventManager.sold_harvest.connect(on_harvest_sold)


func open():
	show()
	EventManager.sell_harvest.emit()


func buy(amount: int):
	EventManager.bought_seeds.emit(amount)


func on_credits_updated(credits: int):
	label_credits.text = str(credits)
	button_buy_1.disabled = credits < SEED_PRICE
	button_buy_5.disabled = credits < 5 * SEED_PRICE
	button_buy_10.disabled = credits < 10 * SEED_PRICE


func on_seeds_updated(seeds: int):
	label_seeds.text = str(seeds)


func on_harvest_sold(harvest: int):
	label_sold.text = "Sold %dX" % harvest


func _on_button_close_pressed() -> void:
	hide()
	closed.emit()
