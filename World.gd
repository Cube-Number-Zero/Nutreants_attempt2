extends Node2D
class_name Game_World

# Declare member variables here.

const PAN_SPEED = 512
const PAN_ACCELERATION = 1024

onready var resource_patches := $resouce_patches
onready var rocks := $rocks
onready var roots := $roots
onready var ResourceManager := $ResourceManager

var camera_pan_velocity = Vector2.ZERO
var is_game_over = false
var game_over_wait = true

#this is here for the sake of pressing the pause button only once rather than it rapdily changing
var esc_down = false
var mouse_position = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	VisualServer.set_default_clear_color(Color(0.22, 0.15, 0.09))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_position = get_viewport().get_mouse_position()
	if not is_game_over:
		Hud.score_count.visible = true
		Hud.score_count.rect_position.x = 1024 - Hud.score_count.rect_size.x - 75
		Hud.score_count.rect_position.y = Hud.score_count.rect_size.y - 75
		Hud.score_count.text = "Score: " + str(round(ResourceManager.score))
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
	else:
		game_over_effects(delta)
	if position.y > 0:
		position.y = 0
		camera_pan_velocity.y = 0
	# Updates the indicator lines for all patches
	if not is_game_over:
		resource_patches.update_indicator_lines()
		
func game_over_effects_single():
	"""Performs all game over effects that should only be called once"""
	Hud.quit_button.visible = false
	Hud.resource_count.visible = false
	Hud.score_count.visible = true
	Hud.score_count.rect_position.x = 362
	Hud.score_count.rect_position.y = 225
	resource_patches.disable_indicator_lines()
	$game_end_timer.start()

func game_over_effects(delta):
	"""Performs all game over effects that should be called every frame"""
	position = (position - Vector2(512, 0)) * pow(0.5, delta) + Vector2(512, 0)
	position.y = ceil(position.y)
	roots.shrivel()
	if not game_over_wait:
		if Input.is_mouse_button_pressed(1):
			Hud.visible = true
			Hud.resource_count.visible = true
			Hud.score_count.text = "Score: "
			Hud.score_count.visible = false
			get_tree().change_scene("MainMenu.tscn")
	


func _on_game_end_timer_timeout():
	game_over_wait = false
