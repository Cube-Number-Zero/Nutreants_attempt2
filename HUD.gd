extends CanvasLayer

onready var quit_button = $ColorRect
onready var resource_count = $ProgressBar

func update_resource_display(count):
	resource_count.value = tanh(count / 100)
