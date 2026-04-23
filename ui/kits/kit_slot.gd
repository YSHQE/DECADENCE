class_name KitSlot extends Node2D


@onready var sprite: Sprite2D = $Sprite

# Debug
@onready var label: Label = $"../Label"


func _ready() -> void:
	# Debug position idk bruh
	# This is also in the joysticks and kit slots
	# Basically all UI elements I have right now
	if name == "KitSlot1":
		global_position.x = get_viewport_rect().size.x - 368
	elif name == "KitSlot2":
		global_position.x = get_viewport_rect().size.x - 208
	label.global_position.x = get_viewport_rect().size.x - 432
