extends AudioStreamPlayer

@export var min_time: float = 10
@export var max_time: float = 30

var timer: float = 0.0
var time: float = min_time
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	
	if timer > time:
		play_ambience()
	pass

func play_ambience():
	time = randf_range(min_time, max_time)
	timer = 0
	play()
	pass
