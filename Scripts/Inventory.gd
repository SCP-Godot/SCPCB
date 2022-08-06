extends Node
class_name Inventory

@export var items: Array[Resource]

signal item_added(item: Item)
signal item_removed(idx: int)

func get_items() -> Array[Resource]:
	return items


# Add an item to the inventory. Returns true if addition was successful, otherwise returns false.
func add_item(item: Item) -> bool:
	if is_valid_item(item):
		items.append(item)
		item_added.emit(item)
		return true
	return false
	
func get_item_at(idx: int) -> Item:
	return items[idx]

# Removes an item from inventory by the item's index. Returns true if successful.
func remove_item(idx: int) -> bool:
	items.remove_at(idx)
	item_removed.emit(idx)
	print("removing")
	return true

func get_item_idx(item: Item) -> int:
	return 0
	
func is_valid_item(item: Resource) -> bool:
	return item.has_method("_on_used")
	
func use_item(idx: int):
	var item = get_item_at(idx)
	if !is_valid_item(item): return
	
	# If there's a use sound, play it.
	if item.use_sound != null:
		set_item_use_sound(item.use_sound)
		play_item_use_sound()
	
	if item.remove_after_use:
		remove_item(idx)

	await get_tree().create_timer(item.use_time).timeout
	item._on_used(get_owner(), self, idx)

func set_item_use_sound(stream: AudioStream):
	%ItemSfx.stream = stream
	
func play_item_use_sound():
	%ItemSfx.play()
