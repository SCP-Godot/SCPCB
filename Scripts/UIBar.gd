extends HBoxContainer

@onready var bar = $PanelContainer/TextureProgressBar
@onready var label = $PanelContainer/TextureProgressBar/MarginContainer/Label

func set_value(input_value: float):
	bar.value = input_value
	label.text = str(round(input_value)) + "%"
