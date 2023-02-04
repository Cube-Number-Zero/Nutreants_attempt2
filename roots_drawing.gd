extends Node


# Declare member variables here.

const MINIMUM_NODE_DISTANCE = 25 # How close adjacent root nodes can be (lowering this makes the vines more smooth at the cost of performance)
const MAXIMUM_DRAW_SNAP_DISTANCE = 40 # How close the cursor needs to be to a node to start drawing from it
const MINIMUM_UNRELATED_NODE_DISTANCE = 50 # How close a root can grow to a seperate root
const ERASER_RADIUS = 60
const MINIMUM_RESOURCE_SNAP_DISTANCE = 25 # How close a node has to be to a resource patch to snap to it and begin collecting
const NEW_NODE = preload("res://tree_root_node.tscn")

var drawing = false # Is the player drawing something?
onready var parent_node = $tree_root_node # The parent node to create new nodes from
var first_node_in_branch = true # Unused
var drawing_branch_ID = "" # Unused, for identifying the specific branch a root is on
var max_root_length = MINIMUM_NODE_DISTANCE # the longest root from the base of the tree; use this (at least partially) for resource consumption scaling
onready var tree_base  = $tree_root_node # Convinience variable for the base of the tree
onready var resource_patches = get_parent().get_child(1)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Create the first root node at the top of the screen
	tree_base.permanent = true
	var new_node = NEW_NODE.instance()
	tree_base.add_child(new_node)
	new_node.position = Vector2(0, MINIMUM_NODE_DISTANCE)
	new_node.get_child(0).get_child(0).set_point_position(0, Vector2(0.0, -40.0))
	new_node.permanent = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	if Input.is_mouse_button_pressed(1):
		if not drawing:
			# Find the closest node to the mouse cursor
			snap_to_node(mouse_position)
	else:
		drawing = false
		
	if drawing:
		if not too_close_to_previous_node(mouse_position):
			if colliding_with_node(mouse_position):
				drawing = false
			else:
				add_node(mouse_position)
	
	if Input.is_mouse_button_pressed(2):
		# The player is right clicking
		tree_base.try_to_erase_at_location(mouse_position, ERASER_RADIUS)
		update_root_network()
		
func snap_to_node(loc):
	var closest_node = tree_base.get_closest_node_to_point(loc)
	if closest_node[1] <= pow(MAXIMUM_DRAW_SNAP_DISTANCE, 2):
		# Begin drawing from the closest node
		drawing = true
		parent_node = closest_node[0]
		first_node_in_branch = true

func update_root_network():
	max_root_length = tree_base.get_longest_distance_from_origin()
	tree_base.get_size()

func add_node(loc, connected = false, connected_resource_patch=null):
	var resource_cost = (loc - parent_node.get_global_position()).length() * sqrt(loc.y) * 0.005
	if ResourceManager.can_afford(resource_cost) or connected:
		var new_node = NEW_NODE.instance()
		parent_node.add_child(new_node)
		new_node.position = loc - parent_node.get_global_position()
		new_node.get_child(0).get_child(0).set_point_position(0, \
			parent_node.get_global_position() - new_node.get_global_position())
			
		# if first_node_in_branch:
			# tree_base.calculate_branch_ID("0")
			# drawing_branch_ID = new_node.branch_ID
		# else:
			# new_node.branch_ID = drawing_branch_ID
		
		parent_node = new_node
		
		if connected:
			new_node.connected_to_patch = true
			new_node.connected_patch = connected_resource_patch
			connected_resource_patch.connect_to()
		else:
			# Play sound
			SoundPlayer.play_grow_root(loc)
		
		ResourceManager.spend(resource_cost)
		
		update_root_network()
		
		var test_gather_resource_patch = resource_patches.test_connection(loc, MINIMUM_RESOURCE_SNAP_DISTANCE)
		if test_gather_resource_patch[0]:
			# This node is close enough to a resource patch to connect to it!
			add_node(test_gather_resource_patch[1].get_global_position(), true, test_gather_resource_patch[1])

func colliding_with_node(loc):
	return tree_base.test_collision(loc, MINIMUM_UNRELATED_NODE_DISTANCE, parent_node.gather_nearby_nodes(1))

func too_close_to_previous_node(loc):
	var squared_distance_from_parent_node = loc.distance_squared_to(parent_node.get_global_position())
	return squared_distance_from_parent_node < pow(MINIMUM_NODE_DISTANCE, 2)
