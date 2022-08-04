extends Sprite2D


@onready var player = get_owner()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.closest_interactable != null:
		visible = true
		update_position()
	else:
		visible = false
	pass

func update_position():
	var pos = player.closest_interactable.global_position
	var cam = get_viewport().get_camera_3d() as Camera3D
	if !cam.is_position_behind(pos):
		position = cam.unproject_position(pos)
	position.x = clamp(position.x, 64, get_viewport().size.x - 64)
	position.y = clamp(position.y, 64, get_viewport().size.y - 64)
