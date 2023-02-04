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
onready var roots = get_parent().get_child(2).get_child(0)
var cost_per_second = 0.0 # The amount of resources drained every second
var base_cost_per_second = 0.0 # Resource cost dependent on time
var resource_income = 0.0 # How many resources the player gets per second from patches
var unexploited_resource_income = 0.0 # How many resources per second the player isn't getting from unexploited nodes

func _ready():
	pass

func _process(delta):
	cost_per_second = 0.0
	
	var max_length = roots.max_root_length - roots.MINIMUM_NODE_DISTANCE
	cost_per_second += max_length * MAX_RESOURCE_COST_MULTIPLIER
	
	cost_per_second += base_cost_per_second
	cost_per_second -= resource_income
	
	resources -= cost_per_second * delta
	base_cost_per_second += BASE_COST_PER_SECOND_INCREASE_RATE * delta

func spend(cost):
	resources -= cost

func can_afford(cost):
	return cost < resources
