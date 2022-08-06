extends Resource
class_name Item

@export var icon: Texture2D
@export var use_sound: AudioStream
@export var name: String = "New Item"
@export var description: String = "This is a cool new item!"
@export var weight: float = 0.1
@export var remove_after_use: bool = false
@export var use_time = 0.0

func _on_used(player: Player, inv: Inventory, idx: int):
	pass
