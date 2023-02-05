extends Node2D

const ROCK_GENERATION_DISTANCE = 300 # How far away to place rocks

var rocks_generated_distance = 150 # How far rocks have been generated to

const NEW_ROCK := preload("res://Rock.tscn")

func _ready():
	randomize()

func check_generation(distance):
	"""Checks to see if rocks have been generated to a given distance
	If not, generates more rocks.
	Returns nothing
	"""
	if distance >= rocks_generated_distance:
		var new_rock = NEW_ROCK.instance()
		add_child(new_rock)
		var distance_from_origin = rocks_generated_distance
		var depth = ROCK_GENERATION_DISTANCE / 3.0
		var width_ratio = lerp(0.4, 0.7, randf())
		var point_space = 50
		new_rock.generate_random_rock_formation(distance_from_origin, depth, width_ratio, point_space) 
		rocks_generated_distance += ROCK_GENERATION_DISTANCE
