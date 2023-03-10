extends Node2D
class_name Rock_Area

onready var poly_visible := $Polygon2D
onready var poly_collide := $Area2D/CollisionPolygon2D
onready var collider := $Area2D

func _ready():
	randomize()
	
func generate_random_rock_formation(distance_from_origin: int, depth: int, width_ratio: float, distance_between_points: int):
	# distance_from_origin = how many pixels the center of the rock formation is from the tree base
	# depth = how thick the rock slab is, in pixels
	# width_ratio = how much of the semicircle the rock should occupy. use a number from 0 to 1, 0 = no rock, 1 = cover full layer
	# distance_between_points = the distance between points on the inner and outer sides, in pixels. Decreasing this makes the rock look more jagged
	"""Initializes the rock formation based on input parameters.
	Returns nothing
	"""
	var point_list = []
	var center_angle_ratio = lerp(width_ratio / 2, 1 - width_ratio / 2, randf())
	var center_angle = lerp(0, PI, center_angle_ratio)
	var start_angle = center_angle - PI * width_ratio / 2
	var end_angle = center_angle + PI * width_ratio / 2
	var length_inner = PI * (distance_from_origin - depth / 2.0) * width_ratio
	var length_outer = PI * (distance_from_origin + depth / 2.0) * width_ratio
	var points_count_inner = round(length_inner / distance_between_points)
	var points_count_outer = round(length_outer / distance_between_points)
	for i in range(points_count_inner + 1):
		var theta = lerp(start_angle, end_angle, i / points_count_inner)
		var new_point = (distance_from_origin - depth / 2.0) * Vector2(cos(theta), sin(theta))
		point_list.append(new_point + get_random_vector2(distance_between_points / 2.0))
	for i in range(points_count_outer + 1):
		var theta = lerp(end_angle, start_angle, i / points_count_outer)
		var new_point = (distance_from_origin + depth / 2.0) * Vector2(cos(theta), sin(theta))
		point_list.append(new_point + get_random_vector2(distance_between_points / 2.0))
	poly_visible.polygon = point_list
	poly_collide.polygon = point_list

func get_random_vector2(max_length: float):
	"""Gets a random vector with a max length of max_length
	Returns the vector
	"""
	var random_angle = randf() * TAU
	var random_length = randf() * max_length
	return Vector2(random_length * cos(random_angle), random_length * sin(random_angle))
