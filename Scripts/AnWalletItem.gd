extends Item

@export_category("Wallet")
@export var coin: Resource
@export var max_uses: int = 3
var uses: int = max_uses

func _on_used(player: Player, inv: Inventory, idx: int):
	if uses == 0:
		use_sound = null
		player.show_message("Seems it's empty now.")
		return
	
	inv.add_item(coin as Item)
	uses -= 1
	pass
