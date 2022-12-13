extends Control

@onready var blink_bar = $HUD/VBoxContainer/BlinkBar
@onready var sprint_bar = $HUD/VBoxContainer/SprintBar

@onready var blink_overlay: ColorRect = $Blink


func _on_player_stamina_changed(new_value: float):
	sprint_bar.set_value(new_value*100)


func _on_player_blink_changed(new_value: float):
	blink_bar.set_value(new_value*100)


func _on_player_eyes_closed():
	blink_overlay.visible = true


func _on_player_eyes_opened():
	blink_overlay.visible = false
