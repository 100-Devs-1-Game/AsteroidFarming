# GDScript script template by Mouse Potato Does Stuff
# @tool
# @icon
# @static_unload
class_name LeaderboardMenu
extends SwappableMenu

## Insert doc comment here.

# Signals

# Enums

# Constants

# ------------------------------------------------------------------------------------------------ #
# Variables
# ------------------------------------------------------------------------------------------------ #
# Static variables

# @export variables
@export var text_display:RichTextLabel

# Other variables

# @onready class variables

# ------------------------------------------------------------------------------------------------ #
# Static methods
# starting with _static_init()
# ------------------------------------------------------------------------------------------------ #


# ------------------------------------------------------------------------------------------------ #
# Overridden built-in methods:
# _init(), _enter_tree(), _ready(), _process(), _physics_process(), and then the rest
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# Overridden custom methods
# ------------------------------------------------------------------------------------------------ #
func enter(new_data:Dictionary)->void:
	self.exported_data.merge(new_data,true)
	var leaderboard:Array[Dictionary]=[]
	leaderboard=self.exported_data.get_or_add("leaderboard",leaderboard)
	var res:Array[String]=[]
	for el in leaderboard:
		var cur:String=el.get("name","???")+"\t\t"+str(el.get("score",-1))
		res.append(cur)
	if res.is_empty():
		res.append("No scores yet.\n\nGo earn some.")
	self.text_display.text="\n".join(res)
	show()
# ------------------------------------------------------------------------------------------------ #
# New methods
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# Subclasses
# ------------------------------------------------------------------------------------------------ #
