extends Node2D

# Declare member variables here.

const PAN_SPEED = 512
const PAN_ACCELERATION = 1024

onready var resource_patches = $resouce_patches
onready var rocks = $rocks
onready var background = $background_rect
onready var ResourceManager = $ResourceManager

var camera_pan_velocity = Vector2.ZERO

#this is here for the sake of pressing the pause button only once rather than it rapdily changing
var esc_down = false
var mouse_position = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_position = get_viewport().get_mouse_position()
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
	if Input.is_action_pressed("ui_cancel"):
		if not esc_down:
			Hud.quit_button.visible = not Hud.quit_button.visible
		esc_down = true
	if not Input.is_action_pressed("ui_cancel"):
		esc_down = false
	if Hud.quit_button.visible:
		if Input.is_mouse_button_pressed(1):
			if mouse_position.x >= Hud.quit_button.rect_position.x and mouse_position.x <= Hud.quit_button.rect_position.x + 340:
				if mouse_position.y >= Hud.quit_button.rect_position.y and mouse_position.y <= Hud.quit_button.rect_position.y + 40:
					get_tree().quit()
	input_vector = input_vector.normalized() * PAN_SPEED
	camera_pan_velocity = camera_pan_velocity.move_toward(input_vector, PAN_ACCELERATION * delta)
	position -= camera_pan_velocity * delta
	if position.y > 0:
		position.y = 0
		camera_pan_velocity.y = 0
	background.rect_position = -position
	# Updates the indicator lines for all patches
	resource_patches.update_indicator_lines()
