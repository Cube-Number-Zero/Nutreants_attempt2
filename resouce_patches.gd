extends Node

const TOTAL_RESOURCE_INCOME_GOAL = 15.0
# Will generate more resource patches until the combined income of
# all unexploited resource patches reaches this value

onready var resource_manager = get_parent().get_child(4)
onready var resource_generator_radius = resource_manager.START_RESOURCE_DISTANCE # How far to generate resources. Increases over time.
onready var rock_generator = get_parent().get_child(3)

const NEW_RESOURCE = preload("res://Resource_patch.tscn")

func _process(_delta):
	if resource_manager.unexploited_resource_income < TOTAL_RESOURCE_INCOME_GOAL:
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
	"""Creates a new resource patch and gives it the appropriate parameters
	Also generates rocks when necessary
	Returns nothing
	"""
	var new_patch = NEW_RESOURCE.instance()
	add_child(new_patch)
	var generation_angle = -lerp(PI, TAU, randf())
	new_patch.position = resource_generator_radius * Vector2(cos(generation_angle), sin(generation_angle))
	resource_manager.unexploited_resource_income += new_patch.resources_per_second
	resource_generator_radius += new_patch.resources_per_second * resource_manager.RESOURCE_SCARCITY
	
	rock_generator.check_generation(resource_generator_radius)

func update_indicator_lines():
	"""Updates the indicator lines that show when a patch is far away.  Affects all resource patches
	"""
	for patch in get_children():
		patch.update_indicator_line()
