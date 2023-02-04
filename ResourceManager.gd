extends Node

var resources = 100.0 # The amount of resources the player has
onready var roots = get_parent().get_child(2).get_child(0)
var cost_per_second = 0.0 # The amount of resources drained every second
var base_cost_per_second = 0.0 # Resource cost dependent on time
var base_cost_per_second_increase_rate = 0.0167 # How fast base_cost_per_second_increases
var resource_income = 0.0 # How many resources the player gets per second from patches

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cost_per_second = 0.0
	
	var max_length = roots.max_root_length - roots.MINIMUM_NODE_DISTANCE
	cost_per_second += max_length * 0.001
	
	cost_per_second += base_cost_per_second
	cost_per_second -= resource_income
	
	resources -= cost_per_second * delta
	base_cost_per_second += base_cost_per_second_increase_rate * delta

func spend(cost):
	resources -= cost

func can_afford(cost):
	return cost < resources
