extends CharacterBody3D
class_name Player

enum State {
	IDLE,
	WALKING,
	RUNNING,
	CROUCHING,
	DEAD
}

var MAX_SPEED = 5
var SPRINT_SPEED = 5
const WALK_SPEED = 3.5
const JUMP_VELOCITY = 4.5
const ACCELERATION = 3
const DEACCELERATION = 8.0

var SPEED: float = 3.5

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var direction: Vector3
var camera: Camera3D
var rot_helper: Node3D

@export var mouse_sensitivity: float = 0.08
@export var footstep_delay: float = 0.6

@export var current_state: State = State.IDLE

var footstep_timer: float = 0.0
@onready var footstep_audio: AudioStreamPlayer3D = $SFX/Footsteps/Concrete 

var can_interact: bool = false

@onready var interact_area: Area3D = $InteractArea

var closest_interactable: Node3D

@export var stamina: float = 1.0
@export var max_stamina: float = 1.0
@export var stamina_deplete_rate: float = 0.001
@export var stamina_regen_rate: float = 0.001
@export var stamina_threshold: float = 0.45
var stamina_regenerating = false
signal stamina_changed(new_value: float)

@export var blink_timer: float = 1.0
@export var max_blink: float = 1.0
@export var blink_deplete_rate: float = 0.1
var blink_current_deplete_rate = blink_deplete_rate
signal blink_changed(new_value: float)
signal eyes_closed
signal eyes_opened



func _ready():
	camera = $RotationHelper/Camera3D
	rot_helper = $RotationHelper
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	%InventoryUI.set_inventory($Inventory)
	pass

func process_input(delta: float):
	direction = Vector3()
	
	var cam_transform = camera.global_transform
	
	var input_vector = Vector2()
	
	if Input.is_action_pressed("move_forward"):
		input_vector.y += 1
	if Input.is_action_pressed("move_backward"):
		input_vector.y -= 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
		
	if Input.is_action_just_pressed("blink"):
		close_eyes()
	else: 
		if Input.is_action_just_released("blink"):
			open_eyes()
	
	# If the player inputs movement actions.
	if input_vector.length() > 0:
		current_state = State.WALKING
	else:
		current_state = State.IDLE
		
	toggle_sprint(Input.is_action_pressed("sprint"))
	
	input_vector = input_vector.normalized()
	
	direction += -cam_transform.basis.z * input_vector.y
	direction += cam_transform.basis.x * input_vector.x
	

func process_movement(delta: float):
	velocity.y -= delta * gravity
	direction.y = 0
	
	var hvel = velocity
	hvel.y = 0
	
	var target = direction
	target *= SPEED
	
	var accel
	if direction.dot(hvel) > 0:
		accel = ACCELERATION
	else:
		accel = DEACCELERATION
		
	hvel = hvel.lerp(target, accel * delta)
	
	velocity.x = hvel.x
	velocity.z = hvel.z
	move_and_slide()


func rotate_helper(event: InputEvent):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rot_helper.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		self.rotate_y(deg_to_rad(event.relative.x * mouse_sensitivity * -1))
		
		var camera_rot = rot_helper.rotation
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rot_helper.rotation = camera_rot

func _process(delta: float):
	process_input(delta)
	process_blink(delta)
	regen_stamina(delta)
	deplete_stamina(delta)
	pass

func _physics_process(delta):
	process_movement(delta)
	
	if current_state == State.WALKING or current_state == State.RUNNING:
		footstep_timer += delta * velocity.length() / SPEED
	if footstep_timer > footstep_delay:
		footstep_audio.play()
		footstep_timer = 0
		
	closest_interactable = get_closest_interactable()
	
	check_stamina()
	pass
	
func _input(event):
	rotate_helper(event)
	if Input.is_action_just_pressed("interact"):
		handle_interact()
		
	if Input.is_action_just_pressed("ui_cancel"):
		Controls.toggle_cursor()
	pass

func handle_interact():
	if closest_interactable == null: return
	closest_interactable.call("_on_interact")
	var message = closest_interactable.call("_get_interact_message") as String
	show_message(message)
	pass

func is_interactable(node: Node) -> bool:
	return node.has_method("_on_interact")
	

func get_close_interactables() -> Array[Area3D]:
	return interact_area.get_overlapping_areas()

func get_closest_interactable() -> Node3D:
	var in_proximity = get_close_interactables()
	var count = in_proximity.size()
	if count == 0:
		return null
	for i in range(count):
		if is_interactable_best_candidate(in_proximity[i], count):
			return in_proximity[i]
#	if is_interactable(interactable) and !point_behind_wall(interactable.global_position):
#		return interactable
	return null

func point_behind_wall(point: Vector3) -> bool:
	var space_state = get_world_3d().direct_space_state
	var params = PhysicsRayQueryParameters3D.new()
	params.from = camera.global_position
	params.to = point
	var result = space_state.intersect_ray(params)
	return !result.is_empty()
	
func looking_at_point(point: Vector3) -> bool:
	var forward = -camera.global_transform.basis.z.normalized()
	var dot = forward.dot(point.direction_to(camera.global_position).normalized())
	return abs(dot) > 1.0 - 0.5

# If this interactable is the best to be picked based on various parameters.
func is_interactable_best_candidate(interactable: Area3D, count: int) -> bool:
	# If there's only one interactable in proximity, don't do dot checks. (useful for door buttons)
	if count == 1:
		return is_interactable(interactable) or !point_behind_wall(interactable.global_position)
	
	return looking_at_point(interactable.global_position)

func toggle_sprint(enabled: bool):
	if current_state == State.IDLE or current_state == State.DEAD: return
	
	var can_run = enabled
	
	if stamina_regenerating:
		can_run = false
	
	if can_run:
		start_running()
	else:
		start_walking()
	pass

func show_message(message: String):
	%MessageLabel.text = "[center]" + message
	%MessageAnimationPlayer.play("show")
	pass
	
func regen_stamina(delta: float):
	if current_state == State.WALKING or current_state == State.IDLE:
		stamina += stamina_regen_rate * delta
		emit_signal("stamina_changed", stamina)
	
	if stamina <= 0.0:
		stamina_regenerating = stamina <= stamina_threshold
		play_breath_sound()
	elif stamina >= stamina_threshold:
		stamina_regenerating = false
	clamp_stamina()
	pass
	
func deplete_stamina(delta: float):
	if current_state == State.RUNNING:
		stamina -= stamina_deplete_rate * delta
		emit_signal("stamina_changed", stamina)
	clamp_stamina()
	pass
	
func clamp_stamina():
	stamina = clamp(stamina, 0.0, max_stamina)
	pass

func check_stamina():
	if stamina <= 0.0:
		start_walking()
	pass

func process_blink(delta: float):
	if blink_timer <= 0.0:
		blink()
	else:
		blink_timer -= blink_current_deplete_rate * delta
		emit_signal("blink_changed", blink_timer)

func blink():
	close_eyes()
	await get_tree().create_timer(0.1).timeout	
	open_eyes()
	
func close_eyes():
	
	emit_signal("eyes_closed")
	blink_current_deplete_rate = 0.0
	blink_timer = max_blink
	emit_signal("blink_changed", blink_timer)

func open_eyes():
	blink_current_deplete_rate = blink_deplete_rate
	emit_signal("eyes_opened")

func start_running():
	current_state = State.RUNNING
	SPEED = SPRINT_SPEED
	footstep_delay = 0.4
	footstep_audio = $SFX/Footsteps/Concrete/ConcreteRun
	pass
	
func start_walking():
	current_state = State.WALKING
	SPEED = WALK_SPEED
	footstep_delay = 0.6
	footstep_audio = $SFX/Footsteps/Concrete
	pass
	
func start_idling():
	current_state = State.IDLE

func play_breath_sound():
	$SFX/Breath.play()
