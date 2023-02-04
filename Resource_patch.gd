extends Node2D

const MIN_VALUE = 1 # The income from the smallest resource vein
const MAX_VALUE = 5 # The income from the largest resource vein
const MIN_RADIUS = 2 # The radius of the smalled resource patch
const MAX_RADIUS = 10 # The radius of the largest resource patch

var polygon_radius
var resources_per_second # How many resources the patch provides
var acquired = false

onready var polygon = $Polygon2D

func _ready():
	randomize()
	randomize_patch_size()
	place_points()
	polygon.color = Color(0.5, 0.75, 1)
	
func randomize_patch_size():
	var normalized_size = randf()
	resources_per_second = lerp(MIN_VALUE, MAX_VALUE, normalized_size)
	polygon_radius = pow(lerp(sqrt(MIN_RADIUS), sqrt(MAX_RADIUS), normalized_size), 2)

func connect_to():
	if acquired:
		print("WARNING: Tried to double collect a resource!")
	else:
		acquired = true
		ResourceManager.resource_income += resources_per_second
		ResourceManager.unexploited_resource_income -= resources_per_second
		polygon.color = Color(0.5, 1, 0.75)

func disconnect_from():
	if acquired:
		acquired = false
		ResourceManager.resource_income -= resources_per_second
		ResourceManager.unexploited_resource_income += resources_per_second
		polygon.color = Color(0.5, 0.75, 1)
	else:
		print("WARNING: Tried to disconnect a non-connected resource!")

func place_points():
	"""Places the points of the polygon in a semi-random area around the center
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
	
