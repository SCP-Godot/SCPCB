extends Item

func _on_used(player: Player, inv: Inventory, idx: int):
	super._on_used(player, inv, idx)
	player.MAX_SPEED = 15
	player.SPRINT_SPEED = 15
	player.show_message("You feel fresh!")
	pass
