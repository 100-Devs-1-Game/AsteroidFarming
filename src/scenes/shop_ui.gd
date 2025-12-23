class_name Shop
extends PanelContainer

signal closed

const SEED_PRICE= 10

@onready var label_credits: Label = %"Label Credits"
@onready var label_seeds: Label = %"Label Seeds"
@onready var button_buy: Button = %"Button Buy"
@onready var label_sold: Label = %Sold
@onready var label_taxes: Label = %"Label Taxes"



func _ready() -> void:
	EventManager.credits_updated.connect(on_credits_updated)
	EventManager.seeds_updated.connect(on_seeds_updated)
	EventManager.sold_harvest.connect(on_harvest_sold)
	EventManager.update_taxes.connect(on_taxes_updated)


func open():
	show()
	EventManager.sell_harvest.emit()
	EventManager.pay_taxes.emit()

func buy(amount: int):
	EventManager.bought_seeds.emit(amount)


func on_credits_updated(credits: int):
	label_credits.text = str(credits)
	button_buy.disabled = credits < SEED_PRICE


func on_seeds_updated(seeds: int):
	label_seeds.text = str(seeds)


func on_harvest_sold(harvest: int):
	if harvest == 0:
		label_sold.text = ""
	else:
		label_sold.text = "Sold: %d" % harvest


func on_taxes_updated(amount: int):
	label_taxes.text = str(amount)


func _on_button_close_pressed() -> void:
	hide()
	closed.emit()
