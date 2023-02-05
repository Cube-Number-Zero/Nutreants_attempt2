extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

var mouse_position = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	mouse_position = get_viewport().get_mouse_position()
	if mouse_position.x >= $NewGame.rect_position.x and mouse_position.x <= $NewGame.rect_position.x + 320:
		if mouse_position.y >= $NewGame.rect_position.y and mouse_position.y <= $NewGame.rect_position.x + 160:
			if Input.is_mouse_button_pressed(1):
				Hud.visible = true
				get_tree().change_scene("World.tscn")
	if mouse_position.x >= $NewGame2.rect_position.x and mouse_position.x <= $NewGame2.rect_position.x + 320:
		if mouse_position.y >= $NewGame2.rect_position.y and mouse_position.y <= $NewGame2.rect_position.x + 160:
			if Input.is_mouse_button_pressed(1):
				get_tree().quit()
