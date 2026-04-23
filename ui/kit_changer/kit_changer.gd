class_name KitChanger extends TouchScreenButton


@export var player: Player:
	get:
		if not player:
			player = get_tree().get_first_node_in_group("Player")
		return player


func _ready() -> void:
	# Debug position idk bruh
	# This is also in the joysticks and kit slots
	# Basically all UI elements I have right now
	global_position.x = get_viewport_rect().size.x - 672


func _on_pressed() -> void:
	var new_kit: int = 0
	if player.current_kit + 1 < player.Kit.size():
		new_kit = player.current_kit + 1

	player.change_kit(new_kit)
