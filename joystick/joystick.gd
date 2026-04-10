class_name Joystick extends Node2D


const STICK_CLAMP: float = 100.0

@export var click_area: float = 320.0

var bounds: Rect2 = Rect2(
		Vector2(-click_area, -click_area), # Top left
		Vector2(click_area, click_area) * 2, # Bottom right
	)

var dir: Vector2 = Vector2.ZERO
var dragging: bool = false

@onready var stick: Marker2D = $Stick
@onready var base: Sprite2D = $Base


func _draw() -> void:
	# Draw clickable area (debug)
	draw_rect(
		Rect2(
			bounds.position,
			bounds.size,
		), 
		Color.WHITE, 
		false, 
		5.0
	)


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.is_pressed():
			if _in_click_area(event.position):
				dragging = true
				_move_joystick(event.position)
		else:
			dragging = false
			_release_joystick()
	elif event is InputEventScreenDrag:
		if dragging:
			_move_joystick(event.position)


func _move_joystick(event_pos: Vector2) -> void:
	# Actual moving
	stick.global_position = event_pos
	dir = stick.global_position - global_position
	Game.joystickPosition = dir.normalized()

	# Purely visual
	stick.global_position = stick.global_position.clamp(
		to_global(Vector2(-STICK_CLAMP, -STICK_CLAMP)),
		to_global(Vector2(STICK_CLAMP, STICK_CLAMP))
	)


func _release_joystick() -> void:
	Game.joystickPosition = Vector2.ZERO

	# Cool animation
	var tween := get_tree().create_tween()
	tween.tween_property(
		stick,
		"global_position",
		global_position,
		0.1
	).set_ease(
		Tween.EASE_OUT).set_trans(
			Tween.TRANS_EXPO)


func _in_click_area(event_pos: Vector2) -> bool:
	# Essentially checks if touch position is inside the clickable area
	if bounds.has_point(to_local(event_pos)):
		return true
	return false
