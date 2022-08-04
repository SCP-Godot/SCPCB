extends "res://Scripts/Interactable.gd"


func _on_interact():
	var play_sound = $PlaySound as AudioStreamPlayer3D
	if !play_sound.playing:
		play_sound.play()
	pass

func _get_interact_message() -> String:
	return ""
