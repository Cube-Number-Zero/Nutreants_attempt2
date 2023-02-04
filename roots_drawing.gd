extends Node


# Declare member variables here.

const MINIMUM_NODE_DISTANCE = 30
const MAXIMUM_DRAW_SNAP_DISTANCE = 100
const NEW_NODE = preload("res://tree_root_node.tscn")

var drawing = false
onready var parent_node = $tree_root_node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_mouse_button_pressed(1):
		drawing = true
	else:
		drawing = false	
	
	if drawing:
		var mouse_position = get_viewport().get_mouse_position()
		var squared_distance_from_parent_node =\
			mouse_position.distance_squared_to(parent_node.get_global_position())
		
		if squared_distance_from_parent_node >= pow(MINIMUM_NODE_DISTANCE, 2):
			var new_node = NEW_NODE.instance()
			parent_node.add_child(new_node)
			new_node.position = mouse_position - parent_node.get_global_position()
			new_node.get_child(0).set_point_position(0, \
				parent_node.get_global_position() - new_node.get_global_position())
			
			parent_node = new_node
