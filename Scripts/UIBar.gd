extends Panel

@onready var bar = $TextureProgressBar
@onready var label = $TextureProgressBar/MarginContainer/Label

func set_value(input_value: float):
	bar.value = input_value
	label.text = str(round(input_value)) + "%"
