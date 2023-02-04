extends Node2D

const DISPLAY_RADIUS = 10 # The radius of the visible patch

var resources_per_second =  8 # How many resources the patch provides
var acquired = false

onready var polygon = $Polygon2D

func _ready():
	randomize()
	place_points()
	polygon.color = Color(0.5, 0.75, 1)

func connect_to():
	if acquired:
		print("WARNING: Tried to double collect a resource!")
	else:
		acquired = true
		ResourceManager.resource_income += resources_per_second

func disconnect_from():
	if acquired:
		acquired = false
		ResourceManager.resource_income -= resources_per_second
	else:
		print("WARNING: Tried to disconnect a non-connected resource!")

func place_points():
	"""Places the points of the polygon in a semi-random area around the center
	"""
	var start_angle = randf() * TAU
	var p1 = DISPLAY_RADIUS * Vector2(cos(start_angle          ), sin(start_angle          ))
	var p2 = DISPLAY_RADIUS * Vector2(cos(start_angle + TAU / 6), sin(start_angle + TAU / 6))
	var p3 = DISPLAY_RADIUS * Vector2(cos(start_angle + TAU / 3), sin(start_angle + TAU / 3))
	var p4 = DISPLAY_RADIUS * Vector2(cos(start_angle + TAU / 2), sin(start_angle + TAU / 2))
	var p5 = DISPLAY_RADIUS * Vector2(cos(start_angle - TAU / 3), sin(start_angle - TAU / 3))
	var p6 = DISPLAY_RADIUS * Vector2(cos(start_angle - TAU / 6), sin(start_angle - TAU / 6))
	var p1_angle = randf() * TAU
	var p2_angle = randf() * TAU
	var p3_angle = randf() * TAU
	var p4_angle = randf() * TAU
	var p5_angle = randf() * TAU
	var p6_angle = randf() * TAU
	p1 += 0.5 * DISPLAY_RADIUS * Vector2(cos(p1_angle), sin(p1_angle))
	p2 += 0.5 * DISPLAY_RADIUS * Vector2(cos(p2_angle), sin(p2_angle))
	p3 += 0.5 * DISPLAY_RADIUS * Vector2(cos(p3_angle), sin(p3_angle))
	p4 += 0.5 * DISPLAY_RADIUS * Vector2(cos(p4_angle), sin(p4_angle))
	p5 += 0.5 * DISPLAY_RADIUS * Vector2(cos(p5_angle), sin(p5_angle))
	p6 += 0.5 * DISPLAY_RADIUS * Vector2(cos(p6_angle), sin(p6_angle))
	var center = (p1 + p2 + p3 + p4 + p5 + p6) / 6
	p1 -= center
	p2 -= center
	p3 -= center
	p4 -= center
	p5 -= center
	p6 -= center
	polygon.polygon = [p1, p2, p3, p4, p5, p6]
	
