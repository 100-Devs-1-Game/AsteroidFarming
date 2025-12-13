@tool
extends GridMap

@export_tool_button("Clear Stone") var clear_stone_action= clear_stone


func clear_stone():
	for pos in get_used_cells():
		if get_cell_item(pos) == 0:
			set_cell_item(pos, -1)
