extends Node

onready var grow_root = $grow_root_sound_player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func play_grow_root(loc):
	grow_root.position = loc
	grow_root.play(0.0)
