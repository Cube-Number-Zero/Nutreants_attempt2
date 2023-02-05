extends Node2D

var buttons_disabled = true

var mouse_position
var play_menu_hover = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	mouse_position = get_viewport().get_mouse_position()
	if not buttons_disabled:
		if (mouse_position.x >= $NewGame.rect_position.x and mouse_position.x <= $NewGame.rect_position.x + $NewGame.rect_size.x * $NewGame.rect_scale.x) and (mouse_position.y >= $NewGame.rect_position.y and mouse_position.y <= $NewGame.rect_position.y + $NewGame.rect_size.y  * $NewGame.rect_scale.y):
			if play_menu_hover:
				SoundPlayer.play_menu_hover()
				play_menu_hover = false
				$NewGame.color = Color(129.0/255.0, 200.0/255.0,76.0/255.0)
				$NewGame.rect_scale.x = 1.25
				$NewGame.rect_position.x = $NewGame.rect_position.x - (40)
				$NewGame.rect_scale.y = 1.25
				$NewGame.rect_position.y = $NewGame.rect_position.y - (5)
			if Input.is_mouse_button_pressed(1):
				Hud.visible = true
				get_tree().change_scene("World.tscn")
		elif (mouse_position.x >= $QuitButton.rect_position.x and mouse_position.x <= $QuitButton.rect_position.x + $QuitButton.rect_size.x * $QuitButton.rect_scale.x) and (mouse_position.y >= $QuitButton.rect_position.y and mouse_position.y <= $QuitButton.rect_position.y + $QuitButton.rect_size.y  * $QuitButton.rect_scale.y):
				if play_menu_hover:
					SoundPlayer.play_menu_hover()
					play_menu_hover = false
					$QuitButton.color = Color(129.0/255.0, 200.0/255.0,76.0/255.0)
					$QuitButton.rect_scale.x = 1.25
					$QuitButton.rect_position.x = $QuitButton.rect_position.x - (40)
					$QuitButton.rect_scale.y = 1.25
					$QuitButton.rect_position.y = $QuitButton.rect_position.y - (5)
				if Input.is_mouse_button_pressed(1):
					get_tree().quit()
		else:
			if not play_menu_hover:
				if($NewGame.rect_scale.x != 1):
					$NewGame.color = Color(1, 1, 1)
					$NewGame.rect_scale.x = 1
					$NewGame.rect_scale.y = 1
					$NewGame.rect_position.x = $NewGame.rect_position.x + (40)
					$NewGame.rect_position.y = $NewGame.rect_position.y + (5)
				if($QuitButton.rect_scale.x != 1):
					$QuitButton.color = Color(1, 1, 1)
					$QuitButton.rect_scale.x = 1
					$QuitButton.rect_scale.y = 1
					$QuitButton.rect_position.x = $QuitButton.rect_position.x + (40)
					$QuitButton.rect_position.y = $QuitButton.rect_position.y + (5)
				
			play_menu_hover = true


func _on_button_cooldown_timeout(): buttons_disabled = false
