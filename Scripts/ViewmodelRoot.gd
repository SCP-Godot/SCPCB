extends Node3D

@onready var camera = get_owner().get_node("RotationHelper/Camera3D")

var timer: float = 0.0

@export var rotation_speed: float = 10
@export var speed: float = 5
@export var max_bob_x: float = 0.005
@export var max_bob_y: float = 0.0025

var bob_pos: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	var camera_pos = camera.global_position
	global_position = Vector3(camera_pos.x, camera_pos.y, camera_pos.z)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var camera_pos = camera.global_position
	global_position = camera_pos + bob_pos
	
	global_rotation = Vector3(lerp_angle(global_rotation.x, camera.global_rotation.x, delta * rotation_speed), lerp_angle(global_rotation.y, camera.global_rotation.y, delta * rotation_speed), lerp_angle(global_rotation.z, camera.global_rotation.z, delta * rotation_speed))
	
	var player = get_owner()
#	if player.moving == true:
#		timer += delta * player.velocity.length() / player.SPEED
		#process_bob(delta)
	pass
	
	
func process_bob(delta):
	bob_pos.x = cos(timer * speed) * max_bob_x
	bob_pos.y = cos(timer * speed * 2) * max_bob_y
	pass
