extends PanelContainer

var idx: int = 0
signal pressed(idx: int)
signal on_pressed

func update_ui(icon: Texture2D, name: String, desc: String, weight: float):
	%ItemIcon.texture = icon
	%ItemName.text = name
	%ItemDesc.text = desc
	%ItemWeight.text = str(weight) + " kg"
	pass

func on_button_pressed():
	pressed.emit(idx)
	on_pressed.emit()
	pass
