extends Node2D


const MIN_RADIUS = 2 # The radius of the smalled resource patch
const MAX_RADIUS = 6 # The radius of the largest resource patch

var polygon_radius
var resources_per_second # How many resources the patch provides
var acquired = false
var lineless = false

onready var polygon = $Polygon2D
onready var line = $Line2D
onready var game_world = get_parent().get_parent()
onready var resource_manager = game_world.ResourceManager

func _ready():
	randomize()
	randomize_patch_size()
	place_points()
	polygon.color = Color(0.5, 0.75, 1)
	
func randomize_patch_size():
	"""Sets the resource value and size to a random value. Smaller patches are more common
	Returns nothing
	"""
	var normalized_size = randf() * randf()
	resources_per_second = lerp(resource_manager.MIN_RESOURCE_VALUE,\
								resource_manager.MAX_RESOURCE_VALUE, normalized_size)
	polygon_radius = pow(lerp(sqrt(MIN_RADIUS), sqrt(MAX_RADIUS), normalized_size), 2)

func connect_to():
	"""Adds the resource value to the player's total income. Does not require the node connecting to it
	Returns nothing
	"""
	if acquired:
		print("WARNING: Tried to double collect a resource!")
	else:
		acquired = true
		resource_manager.resource_income += resources_per_second
		resource_manager.unexploited_resource_income -= resources_per_second
		polygon.color = Color(0.5, 1, 0.75)
		if not lineless:
			line.queue_free()
		lineless = true
		

func disconnect_from():
	"""Reverts this patch to its original state. The offscreen indicator line remains permanently disabled.
	Returns nothing
	"""
	if acquired:
		acquired = false
		resource_manager.resource_income -= resources_per_second
		resource_manager.unexploited_resource_income += resources_per_second
		polygon.color = Color(0.5, 0.75, 1)
	else:
		print("WARNING: Tried to disconnect a non-connected resource!")

func place_points():
	"""Places the points of the polygon in a semi-random area around the center
	Returns nothing
	"""
	var start_angle = randf() * TAU
	var p1 = polygon_radius * Vector2(cos(start_angle          ), sin(start_angle          ))
	var p2 = polygon_radius * Vector2(cos(start_angle + TAU / 6), sin(start_angle + TAU / 6))
	var p3 = polygon_radius * Vector2(cos(start_angle + TAU / 3), sin(start_angle + TAU / 3))
	var p4 = polygon_radius * Vector2(cos(start_angle + TAU / 2), sin(start_angle + TAU / 2))
	var p5 = polygon_radius * Vector2(cos(start_angle - TAU / 3), sin(start_angle - TAU / 3))
	var p6 = polygon_radius * Vector2(cos(start_angle - TAU / 6), sin(start_angle - TAU / 6))
	var p1_angle = randf() * TAU
	var p2_angle = randf() * TAU
	var p3_angle = randf() * TAU
	var p4_angle = randf() * TAU
	var p5_angle = randf() * TAU
	var p6_angle = randf() * TAU
	p1 += 0.5 * polygon_radius * Vector2(cos(p1_angle), sin(p1_angle))
	p2 += 0.5 * polygon_radius * Vector2(cos(p2_angle), sin(p2_angle))
	p3 += 0.5 * polygon_radius * Vector2(cos(p3_angle), sin(p3_angle))
	p4 += 0.5 * polygon_radius * Vector2(cos(p4_angle), sin(p4_angle))
	p5 += 0.5 * polygon_radius * Vector2(cos(p5_angle), sin(p5_angle))
	p6 += 0.5 * polygon_radius * Vector2(cos(p6_angle), sin(p6_angle))
	var center = (p1 + p2 + p3 + p4 + p5 + p6) / 6
	p1 -= center
	p2 -= center
	p3 -= center
	p4 -= center
	p5 -= center
	p6 -= center
	polygon.polygon = [p1, p2, p3, p4, p5, p6]
	
func update_indicator_line():
	"""Updates this patch's inicator arrow
	Returns nothing
	"""
	if not lineless:
		line.position = Vector2(512, 300) - position - 1 * game_world.position
		if not is_inside_camera_view(get_global_position(), 50):
			line.set_point_position(0, (-line.position).normalized() * 290)
			line.set_point_position(1, (-line.position).normalized() * 300)
			line.visible = true
		else:
			line.visible = false
			
func disable_indicator_line():
	"""Disables this patch's inicator arrow
	Returns nothing
	"""
	if not lineless:
		lineless = true
		line.queue_free()

func is_inside_camera_view(loc, tolerance=0):
	"""Returns true if <loc> is inside the player's view, or within a certain <tolerance>
	"""
	if loc.x < -tolerance:
		return false
	if loc.y < -tolerance:
		return false
	if loc.x >= 1024 + tolerance:
		return false
	if loc.y >= 600 + tolerance:
		return false
	return true
