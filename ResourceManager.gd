extends Node


# v v v Use these to balance the game! v v v
const MAX_RESOURCE_COST_MULTIPLIER = 0.001 # Cost multiplier for the longest path
const BASE_COST_PER_SECOND_INCREASE_RATE = 0.167 # How fast base_cost_per_second_increases
const RESOURCE_SCARCITY = 40.0 # How far you need to travel to get one resource per second, on average
const START_RESOURCE_DISTANCE = 125.0 # How far the closest resource is at the start of the game
const MIN_RESOURCE_VALUE = 0.375 # The income from the smallest resource vein
const MAX_RESOURCE_VALUE = 1.875 # The income from the largest resource vein
const START_RESOURCES = 200 # The amount of resources the player starts with


var resources = START_RESOURCES # The amount of resources the player has
var cost_per_second = 0.0 # The amount of resources drained every second
var base_cost_per_second = 0.0 # Resource cost dependent on time
var resource_income = 0.0 # How many resources the player gets per second from patches
var unexploited_resource_income = 0.0 # How many resources per second the player isn't getting from unexploited nodes
var max_length = 0.0

func _process(delta):
	# Update the resource cost
	cost_per_second = 0.0
	
	cost_per_second += max_length * MAX_RESOURCE_COST_MULTIPLIER
	
	cost_per_second += base_cost_per_second
	cost_per_second -= resource_income
	
	resources -= cost_per_second * delta
	base_cost_per_second += BASE_COST_PER_SECOND_INCREASE_RATE * delta
	
	Hud.update_resource_display(resources)
	
	if cost_per_second < 0 and resources < 0:
		# The player has lost
		get_tree().change_scene("MainMenu.tscn")

func spend(cost):
	"""Spends <cost> resources
	Returns nothing
	"""
	resources -= cost

func can_afford(cost):
	"""Returns true if the player has at least <cost> resources in reserve
	"""
	return cost < resources
