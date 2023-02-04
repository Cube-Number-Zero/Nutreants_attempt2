extends Node


# Declare member variables here.

const MINIMUM_NODE_DISTANCE = 25 # How close adjacent root nodes can be (lowering this makes the vines more smooth at the cost of performance)
const MAXIMUM_DRAW_SNAP_DISTANCE = 40 # How close the cursor needs to be to a node to start drawing from it
const MINIMUM_UNRELATED_NODE_DISTANCE = 50 # How close a root can grow to a seperate root
const NEW_NODE = preload("res://tree_root_node.tscn")

var drawing = false # Is the player drawing something?
onready var parent_node = $tree_root_node # The parent node to create new nodes from
var first_node_in_branch = true # Unused
var drawing_branch_ID = "" # Unused, for identifying the specific branch a root is on
var max_root_length = MINIMUM_NODE_DISTANCE # the longest root from the base of the tree; use this (at least partially) for resource consumption scaling

# Called when the node enters the scene tree for the first time.
func _ready():
	# Create the first root node at the top of the screen
	var new_node = NEW_NODE.instance()
	$tree_root_node.add_child(new_node)
	new_node.position = Vector2(0, MINIMUM_NODE_DISTANCE)
	new_node.get_child(0).get_child(0).set_point_position(0, Vector2(0.0, -40.0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	if Input.is_mouse_button_pressed(1):
		if not drawing:
			# Find the closest node to the mouse cursor
			var closest_node = $tree_root_node.get_closest_node_to_point(mouse_position)
			if closest_node[1] <= pow(MAXIMUM_DRAW_SNAP_DISTANCE, 2):
				# Begin drawing from the closest node
				drawing = true
				parent_node = closest_node[0]
				first_node_in_branch = true
	else:
		drawing = false
		
	if drawing:
		var squared_distance_from_parent_node =\
			mouse_position.distance_squared_to(parent_node.get_global_position())
		
		if squared_distance_from_parent_node >= pow(MINIMUM_NODE_DISTANCE, 2):
			# Create a list of the adjacent few nodes (so the root won't collide with nodes it's attached to)
			# I'm going to improve this later, it's kind of janky right now
			var ignored_node_list = [parent_node.get_global_position(), parent_node.get_parent().get_global_position(), parent_node.get_parent().get_parent().get_global_position()]
			if parent_node.get_child_count() >= 2:
				ignored_node_list.append(parent_node.get_child(1).get_global_position())
				if parent_node.get_child(1).get_child_count() >= 2:
					ignored_node_list.append(parent_node.get_child(1).get_child(1).get_global_position())
			# Test to see if the node collides with any other nodes
			if $tree_root_node.test_collision(mouse_position, MINIMUM_UNRELATED_NODE_DISTANCE, ignored_node_list):
					
				# The root being drawn collided with another root!
				drawing = false
			else:
				# Create the next node
				var new_node = NEW_NODE.instance()
				parent_node.add_child(new_node)
				new_node.position = mouse_position - parent_node.get_global_position()
				new_node.get_child(0).get_child(0).set_point_position(0, \
					parent_node.get_global_position() - new_node.get_global_position())
				
				# if first_node_in_branch:
					# $tree_root_node.calculate_branch_ID("0")
					# drawing_branch_ID = new_node.branch_ID
				# else:
					# new_node.branch_ID = drawing_branch_ID
					
				parent_node = new_node
				# Recalculate the longest distance
				max_root_length = $tree_root_node.get_longest_distance_from_origin()
