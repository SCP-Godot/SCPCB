extends CenterContainer

@export var item_slot_scene: PackedScene
var inventory: Inventory

#func _ready():
#	pass

func set_inventory(inv: Inventory):
	inventory = inv
	update_items()
	connect_signals()
	pass
	
func connect_signals():
	inventory.item_added.connect(self.add_item_ui)
	inventory.item_removed.connect(remove_item_idx)

func update_items():
	for i in range(inventory.items.size()):
		var item = inventory.items[i] as Item
		if !inventory.is_valid_item(item): continue
		add_item_ui(item)

func add_item_ui(item: Item):
	var slot = item_slot_scene.instantiate()
	slot.update_ui(item.icon, item.name, item.description, item.weight)
	%ItemSlotContainer.add_child(slot)
	
	slot.idx = %ItemSlotContainer.get_children().size() - 1
	slot.pressed.connect(inventory.use_item)
	slot.on_pressed.connect(self.toggle)
	pass
	
func remove_item_idx(idx: int):
	print("removing slot at " + idx)
	var slot = %ItemSlotContainer.get_children()[idx]
	slot.queue_free()
	
	update_slot_indexes()
	pass

func update_slot_indexes():
	var slots = %ItemSlotContainer.get_children()
	
	for i in range(slots.size()):
		slots[i].idx = i - 1
		

func _input(event):
	if Input.is_action_just_pressed("inventory"):
		toggle()

func toggle():
	visible = !visible
	Controls.toggle_cursor()
