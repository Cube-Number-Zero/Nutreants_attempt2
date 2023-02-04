extends Node2D

# Declare member variables here.

const PAN_SPEED = 512
const PAN_ACCELERATION = 1024

onready var resource_patches = $resouce_patches
onready var rocks = $rocks
onready var background = $background_rect

var camera_pan_velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Pan the camera
	var input_vector = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		input_vector -= Vector2(0, 1)
	if Input.is_action_pressed("ui_right"):
		input_vector += Vector2(1, 0)
	if Input.is_action_pressed("ui_down"):
		input_vector += Vector2(0, 1)
	if Input.is_action_pressed("ui_left"):
		input_vector -= Vector2(1, 0)
	input_vector = input_vector.normalized() * PAN_SPEED
	camera_pan_velocity = camera_pan_velocity.move_toward(input_vector, PAN_ACCELERATION * delta)
	position -= camera_pan_velocity * delta
	if position.y > 0:
		position.y = 0
		camera_pan_velocity.y = 0
	$background_rect.rect_position = -position
	resource_patches.update_indicator_lines()
