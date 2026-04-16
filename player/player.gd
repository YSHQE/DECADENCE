class_name Player extends CharacterBody2D


@export_group("Movement")
@export var move_speed: float = 700.0
@export_subgroup("Dash")
@export var dash_speed: float = 1500.0
@export var dash_distance: float = 200.0

enum State {
	IDLE,
	MOVING,
	DASH,
	DASHING,
}

var current_state: State = State.IDLE

var can_dash: bool = true
var dashing: bool = false
var dash_target_point: Vector2 = Vector2.ZERO


@onready var dash_timer: Timer = $DashTimer
@onready var state_label: Label = $StateLabel


func _physics_process(delta: float) -> void:
	var move_dir := Input.get_vector(
		"move_left", "move_right", "move_up", "move_down").normalized()

	# Process states
	match current_state:
		State.IDLE: _process_idle()
		State.MOVING: _process_moving(move_dir)
		#State.DASH: _process_dash()
		#State.DASHING: _process_dashing()

	# Transition states
	if dashing:
		current_state = State.DASHING
	elif dashing and can_dash:
		current_state = State.DASH
	elif move_dir != Vector2.ZERO:
		current_state = State.MOVING
	else:
		current_state = State.IDLE

	state_label.text = print_state(current_state)

	move_and_slide()


func print_state(state: int) -> String:
	match state:
		State.IDLE: return "idle"
		State.MOVING: return "moving"
		State.DASH: return "dash" 
		State.DASHING: return "dashing"
	return "man idk"


func _process_idle() -> void:
	if (velocity != Vector2.ZERO):
		velocity = Vector2.ZERO


func _process_moving(dir: Vector2) -> void:
	velocity = dir * move_speed
