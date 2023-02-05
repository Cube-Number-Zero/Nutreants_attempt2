extends Node2D

var buttons_disabled = true

var mouse_position
var play_menu_hover = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	mouse_position = get_viewport().get_mouse_position()
	if not buttons_disabled:
		if (mouse_position.x >= $NewGame.rect_position.x and mouse_position.x <= $NewGame.rect_position.x + 320) and (mouse_position.y >= $NewGame.rect_position.y and mouse_position.y <= $NewGame.rect_position.y + 40):
			if play_menu_hover:
				SoundPlayer.play_menu_hover($NewGame.rect_position)
				play_menu_hover = false
			if Input.is_mouse_button_pressed(1):
				Hud.visible = true
				get_tree().change_scene("World.tscn")
		elif (mouse_position.x >= $QuitButton.rect_position.x and mouse_position.x <= $QuitButton.rect_position.x + 320) and (mouse_position.y >= $QuitButton.rect_position.y and mouse_position.y <= $QuitButton.rect_position.y + 40):
				if play_menu_hover:
					SoundPlayer.play_menu_hover($NewGame.rect_position)
					play_menu_hover = false
				if Input.is_mouse_button_pressed(1):
					get_tree().quit()
		else:
			play_menu_hover = true


func _on_button_cooldown_timeout():
	buttons_disabled = false
