extends Node

onready var grow_root = $grow_root_sound_player

func play_grow_root(loc):
	"""Plays the grow_root sound effect at <loc>
	Returns nothing
	"""
	grow_root.position = loc
	grow_root.play(0.0)
