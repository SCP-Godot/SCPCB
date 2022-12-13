extends Control

@onready var blink_overlay: ColorRect = $Blink

func _on_player_eyes_closed():
	blink_overlay.visible = true


func _on_player_eyes_opened():
	blink_overlay.visible = false
