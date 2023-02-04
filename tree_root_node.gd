extends Node2D

# Declare member variables here.

var is_tree_origin = true
var distance_from_origin = 0
var branch_ID = "0"
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
	var own_result = [self, loc.distance_squared_to(self.get_global_position())]
	if get_child_count() == 1:
		return own_result
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

func test_collision(loc, collision_distance, ignored_loc):
	if self.get_global_position().distance_squared_to(loc) <= pow(collision_distance, 2):
		if self.get_global_position() != ignored_loc:
			return true
	for childNode in get_children():
		if childNode.name != "node_stuff":
			if childNode.test_collision(loc, collision_distance, ignored_loc):
				return true
	return false
