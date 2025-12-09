extends Button

signal tool_selected(index: int)

@export var tool_index: int
@export var texture: Texture2D

@onready var texture_rect: TextureRect = $TextureRect



func _ready() -> void:
	pressed.connect(_on_pressed)
	texture_rect.texture = texture


func _on_pressed() -> void:
	tool_selected.emit(tool_index)
