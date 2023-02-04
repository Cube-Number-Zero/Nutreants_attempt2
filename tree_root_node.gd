extends Node2D

# Declare member variables here.

var is_tree_origin = true
var distance_from_origin = 0
var branch_ID = "0"
var longest_distance = 0
# The branch ID differentiates nodes that have branched off in different ways. 
# Each time there is a fork in the root system, each path has a different number added to its ID
# they look like this: 0.1.1.0.2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_closest_node_to_point(loc):
	"""Finds which node is closest to a given location
	Only call this node from the base tree_root_node
	Outputs an array with the node object itself and the distance to the location
	[node, distance]"""
	# Tests how close this node is to the location
	var own_result = [self, loc.distance_squared_to(get_global_position())]
	if get_child_count() == 1:
		return own_result
		
	# Tests to see if this node's children are closer and returns their result if so
	elif get_child_count() == 2:
		var best_child = $tree_root_node.get_closest_node_to_point(loc)
		if own_result[1] < best_child[1]:
			return own_result
		else:
			return best_child
	else:
		var children_result_list = []
		for childNode in get_children():
			if childNode.name != "node_stuff":
				children_result_list.append(childNode.get_closest_node_to_point(loc))
		var minimum_distance_found = children_result_list[0]
		for output in children_result_list:
			if output[1] < minimum_distance_found[1]:
				minimum_distance_found = output
		if own_result[1] < minimum_distance_found[1]:
			return own_result
		else:
			return minimum_distance_found
			
func calculate_branch_ID(parent_branch_ID):
	"""Unused, call from the base tree_root_node
	Calculates branch_IDs for all nodes
	"""
	branch_ID = parent_branch_ID
	if get_child_count() == 2:
		$tree_root_node.calculate_branch_ID(parent_branch_ID)
	elif get_child_count() > 2:
		var choice_ID = 0
		for child in get_children():
			if child.name != "node_stuff":
				child.calculate_branch_ID(parent_branch_ID + "." + str(choice_ID))
				choice_ID += 1
				
func get_next_branch_ID():
	return branch_ID + "." + str(get_child_count() - 1)

func test_collision(loc, collision_distance, ignored_locs=[]):
	"""Tests to see if a location is within collision distance of a node
	Can provide locations to ignore in the search
	Returns a float distance
	"""
	if get_global_position().distance_squared_to(loc) <= pow(collision_distance, 2):
		if not get_global_position() in ignored_locs:
			return true
	for childNode in get_children():
		if childNode.name != "node_stuff":
			if childNode.test_collision(loc, collision_distance, ignored_locs):
				return true
	return false
	
func get_longest_distance_from_origin():
	"""Finds the longest root from the origin and returns the length
	Call from the base tree_root_node
	Returns a float distance
	"""
	if get_child_count() == 1:
		return get_global_position().distance_to(get_parent().get_global_position())
	var longest_child_distance = null
	for childNode in get_children():
		if childNode.name != "node_stuff":
			var this_child_distance = childNode.get_longest_distance_from_origin()
			this_child_distance += childNode.get_global_position().distance_to(get_global_position())
			if longest_child_distance == null:
				longest_child_distance = this_child_distance
			else:
				longest_child_distance = max(longest_child_distance, this_child_distance)
	return longest_child_distance

func update_line2D():
	"""Call this again if you for some reason move a node after it's been placed
	Only affects the specific node it's called on
	"""
	$node_stuff/Line2D.set_point_position(0, get_parent().get_global_position() - get_global_position())
