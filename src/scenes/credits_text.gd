extends RichTextLabel

@export var credits_file_path:="res://roll.credits"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	return

func figure_it_out_yourself_idgaf():
	if not FileAccess.file_exists(credits_file_path):
		self.text="File %s missing!" % [credits_file_path]
	var file=FileAccess.open(credits_file_path,FileAccess.READ)
	self.text=file.get_as_text()
	file.close()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
