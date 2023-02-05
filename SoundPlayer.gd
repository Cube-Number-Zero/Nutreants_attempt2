extends Node

onready var grow_root = $grow_root_sound_player
onready var rock_grow = $rocky_grow_root_sound_player
onready var collect_1 = $collect_resources_sound_player_1
onready var collect_2 = $collect_resources_sound_player_2
onready var collect_3 = $collect_resources_sound_player_3
onready var collect_4 = $collect_resources_sound_player_4
onready var menu_sound_hover = $menu_hover

func _ready():
	randomize()

func play_grow_root(loc):
	"""Plays the grow_root sound effect at <loc>
	Returns nothing
	"""
	grow_root.position = loc
	grow_root.play(0.0)

func play_rock_grow(loc):
	"""Plays the rock_grow sound effect at <loc>
	Returns nothing
	"""
	rock_grow.position = loc
	rock_grow.play(0.1)

func play_collect_resources(loc):
	"""Plays the collect sound effect at <loc>
	Returns nothing
	"""
	var collect = [collect_1, collect_2, collect_3, collect_4]
	collect = collect[randi() % 4]
	collect.position = loc
	collect.play(0.0)
	
func play_menu_hover(loc):
	menu_sound_hover.position = loc
	menu_sound_hover.play(0.0)
