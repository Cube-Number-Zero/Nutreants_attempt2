extends Node2D

onready var poly_visible = $Polygon2D
onready var poly_collide = $Area2D/CollisionPolygon2D
onready var collider = $Area2D

func _ready():
	randomize()
	generate_random_rock_formation(500, 200, 0.6, 100)
	
func generate_random_rock_formation(distance_from_origin, depth, width_ratio, distance_between_points):
	# distance_from_origin = how many pixels the center of the rock formation is from the tree base
	# depth = how thick the rock slab is, in pixels
	# width_ratio = how much of the semicircle the rock should occupy. use a number from 0 to 1, 0 = no rock, 1 = cover full layer
	# distance_between_points = the distance between points on the inner and outer sides, in pixels. Decreasing this makes the rock look more jagged
	var point_list = []
	var center_angle_ratio = lerp(width_ratio / 2, 1 - width_ratio / 2, randf())
	var center_angle = lerp(0, PI, center_angle_ratio)
	var start_angle = center_angle - PI * width_ratio / 2
	var end_angle = center_angle + PI * width_ratio / 2
	var length_inner = PI * (distance_from_origin - depth / 2) * width_ratio
	var length_outer = PI * (distance_from_origin + depth / 2) * width_ratio
	var points_count_inner = round(length_inner / distance_between_points)
	var points_count_outer = round(length_outer / distance_between_points)
	for i in range(points_count_inner + 1):
		var theta = lerp(start_angle, end_angle, i / points_count_inner)
		var new_point = (distance_from_origin - depth / 2) * Vector2(cos(theta), sin(theta))
		point_list.append(new_point + get_random_vector2(depth / 3))
	for i in range(points_count_outer + 1):
		var theta = lerp(end_angle, start_angle, i / points_count_outer)
		var new_point = (distance_from_origin + depth / 2) * Vector2(cos(theta), sin(theta))
		point_list.append(new_point + get_random_vector2(depth / 3))
	poly_visible.polygon = point_list
	poly_collide.polygon = point_list

func get_random_vector2(max_length):
	var random_angle = randf() * TAU
	var random_length = randf() * max_length
	return Vector2(random_length * cos(random_angle), random_length * sin(random_angle))
