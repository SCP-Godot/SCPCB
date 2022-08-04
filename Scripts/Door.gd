extends Node3D

@export var can_open: bool = true
var opened: bool = false

func interact():
	if !can_interact(): return
	if opened:
		close()
	else:
		open()

func open():
	opened = true
	if can_open:
		play_open_anim()
		play_open_sound()
	pass

func close():
	opened = false
	play_close_anim()
	play_close_sound()
	pass
	

func play_open_anim():
	var anim_player = get_node("AnimationPlayer") as AnimationPlayer
	anim_player.play("Open")

func play_close_anim():
	var anim_player = get_node("AnimationPlayer") as AnimationPlayer
	anim_player.play_backwards("Open")

func play_open_sound():
	var sound = get_node("DoorOpenSound") as AudioStreamPlayer3D
	sound.play()

func play_close_sound():
	var sound = get_node("DoorCloseSound") as AudioStreamPlayer3D
	sound.play()
	
func can_interact() -> bool:
	var anim_player = get_node("AnimationPlayer") as AnimationPlayer
	return can_open and !anim_player.is_playing()
