extends Node2D

# Declare member variables here.

const PAN_SPEED = 256

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Pan the camera
	if Input.is_action_pressed("ui_up"):
		position.y = min(position.y + PAN_SPEED * delta, 0)
	if Input.is_action_pressed("ui_right"):
		position.x -= PAN_SPEED * delta
	if Input.is_action_pressed("ui_down"):
		position.y -= PAN_SPEED * delta
	if Input.is_action_pressed("ui_left"):
		position.x += PAN_SPEED * delta
