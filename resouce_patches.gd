extends Node

const TOTAL_RESOURCE_INCOME_GOAL = 100.0
# Will generate more resource patches until the combined income of
# all unexploited resource patches reaches this value
const RESOURCE_SCARCITY = 10 # How far you need to travel to get one resource per second, on average

var resource_generator_radius = 500.0 # How far to generate resources. Increases over time.

const NEW_RESOURCE = preload("res://Resource_patch.tscn")

func _ready():
	pass

func _process(delta):
	if ResourceManager.unexploited_resource_income < TOTAL_RESOURCE_INCOME_GOAL:
		generate_resource_patch()

func test_connection(loc, connection_range):
	"""Tests to see if any resource patches are within <connection_range> of <loc>
	Returns an array with a boolean for if any patches are close enough and the patch, if there is one
	"""
	for childPatch in get_children():
		if not childPatch.acquired:
			if loc.distance_squared_to(childPatch.get_global_position()) <= pow(connection_range, 2):
				return [true, childPatch]
	return [false]

func generate_resource_patch():
	var new_patch = NEW_RESOURCE.instance()
	add_child(new_patch)
	var generation_angle = -lerp(PI, TAU, randf())
	new_patch.position = resource_generator_radius * Vector2(cos(generation_angle), sin(generation_angle))
	ResourceManager.unexploited_resource_income += new_patch.resources_per_second
	resource_generator_radius += new_patch.resources_per_second * RESOURCE_SCARCITY
