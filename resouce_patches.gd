extends Node

func _ready():
	pass

func _process(delta):
	pass

func test_connection(loc, connection_range):
	"""Tests to see if any resource patches are within <connection_range> of <loc>
	Returns an array with a boolean for if any patches are close enough and the patch, if there is one
	"""
	for childPatch in get_children():
		if not childPatch.acquired:
			if loc.distance_squared_to(childPatch.position) <= pow(connection_range, 2):
				return [true, childPatch]
	return [false]
