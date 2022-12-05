extends HBoxContainer


@export var player: Player
@onready var bar = $PanelContainer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bar.set_value(player.blink_timer*100)
