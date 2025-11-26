# GDScript script template by Mouse Potato Does Stuff
# @tool
# @icon
# @static_unload
# class_name VariousControl
extends Node

## Insert doc comment here.

# Signals

# Enums

# Constants

# ------------------------------------------------------------------------------------------------ #
# Variables
# ------------------------------------------------------------------------------------------------ #
# Static variables

# @export variables
@export var input_audio_streams:Array[AudioStreamPlayer]

# Other variables
var audio_stream_dict:Dictionary[String,AudioStreamPlayer]

# @onready class variables

# ------------------------------------------------------------------------------------------------ #
# Static methods
# starting with _static_init()
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# Overridden built-in methods:
# _init(), _enter_tree(), _ready(), _process(), _physics_process(), and then the rest
# ------------------------------------------------------------------------------------------------ #
func _init() -> void:
	for audio_stream in input_audio_streams:
		audio_stream_dict[audio_stream.name]=audio_stream
	
# ------------------------------------------------------------------------------------------------ #
# Overridden custom methods
# ------------------------------------------------------------------------------------------------ #

# ------------------------------------------------------------------------------------------------ #
# New methods
# ------------------------------------------------------------------------------------------------ #
func play_stream(name:String):
	if name not in audio_stream_dict:
		push_warning("Audio player %s not present!")
# ------------------------------------------------------------------------------------------------ #
# Subclasses
# ------------------------------------------------------------------------------------------------ #
