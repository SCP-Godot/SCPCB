extends "res://Scripts/Interactable.gd"

@onready var door = get_owner()

func _on_interact():
	if door.can_interact():
		play_press_sound()
		door.interact()
	else:
		play_press_fail_sound()
	pass

func _get_interact_message() -> String:
	if !door.can_open:
		return "Door won't open."
	return ""

func play_press_sound():
	var sound_player = get_node("Press") as AudioStreamPlayer3D
	sound_player.play()

func play_press_fail_sound():
	var sound_player = get_node("PressFail") as AudioStreamPlayer3D
	sound_player.play()
