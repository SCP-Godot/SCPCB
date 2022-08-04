extends Camera3D

var timer: float = 0.0

@export var enable_bobbing: bool = true
@export var speed: float = 5
@export var zoom_speed: float = 5
@export var max_bob_x: float = 0.05
@export var max_bob_y: float = 0.05

var speed_multiplier: float = 1.0

@onready var player = get_owner()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if player.current_state == player.State.WALKING or player.current_state == player.State.RUNNING and enable_bobbing:
		timer += delta * player.velocity.length() / player.SPEED * speed_multiplier
		process_bob(delta)

	if player.current_state == player.State.RUNNING:
		fov = lerp(fov, 80, delta * zoom_speed)
	else:
		fov = lerp(fov, 75, delta * zoom_speed)
		
	
func process_bob(delta):
	position.x = cos(timer * speed) * max_bob_x
	position.y = sin(timer * speed * 2) * max_bob_y

	if player.current_state == player.State.RUNNING:
		speed_multiplier = 1.4
	else:
		speed_multiplier = 1
	pass
