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
var dash_target_point: Vector2 = Vector2.ZERO


@onready var dash_timer: Timer = $DashTimer


func _physics_process(delta: float) -> void:
	var moving := Input.is_action_pressed("click")

	# Process states
	match current_state:
		State.IDLE: _process_idle()
		State.MOVING: _process_moving()
		State.DASH: _process_dash()
		State.DASHING: _process_dashing()

	# Transition states
	if dash_timer_is_running():
		current_state = State.DASHING
	elif Input.is_action_just_pressed("dash"):
		current_state = State.DASH
	elif moving:
		current_state = State.MOVING
	else:
		current_state = State.IDLE

	#print_state(current_state)

	move_and_slide()


func print_state(state: int) -> void:
	match state:
		State.IDLE: pass
		State.MOVING: print("moving")
		State.DASH: print("dash")
		State.DASHING: print("dashing")
		_: print("you are somehow out of bounds")


func _process_idle() -> void:
	if (velocity != Vector2.ZERO):
		velocity = Vector2.ZERO


func _process_moving() -> void:
	velocity = Game.joystickPosition * move_speed


func _process_dash() -> void:
	can_dash = false

	dash_target_point = Game.joystickPosition * dash_distance
	dash_timer.start()

	print(dash_target_point)


func _process_dashing() -> void:
	velocity = Game.joystickPosition * dash_speed


func dash_timer_is_running() -> bool:
	return not dash_timer.is_stopped()


func _on_dash_timer_timeout() -> void:
	can_dash = true
