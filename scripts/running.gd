extends PlayerState
# Extiende el playerstate nada mas para que sea mas facil jalar el playable character y sus variables
var is_changing_scene: bool = false

func enter(previous_state_path: String, data := {}) -> void:
	animation_tree["parameters/conditions/move"] = true
	SignalBus.connect("starts_talking", starts_talking_run)

	if !SignalBus.is_connected("changing_scene", changing_scene_run):
		SignalBus.connect("changing_scene", changing_scene_run)

	if !SignalBus.is_connected("starts_fighting", get_caught_running):
		SignalBus.connect("starts_fighting", get_caught_running)
	print('entra running')

func physics_update(_delta: float) -> void:
	var input_x := Input.get_action_strength("right") - Input.get_action_strength("left")
	var input_y := Input.get_action_strength("down") - Input.get_action_strength("up")

	# Prevent flickering by prioritizing last direction if both inputs are pressed
	if Input.is_action_pressed("right") and Input.is_action_pressed("left"):
		input_x = last_facing_direction.x  # Maintain previous direction
	if Input.is_action_pressed("down") and Input.is_action_pressed("up"):
		input_y = last_facing_direction.y  # Maintain previous direction

	direction = Vector2(input_x, input_y)

	if direction.length() > 1.0:
		direction = direction.normalized()
	
	if direction != Vector2.ZERO:
		last_facing_direction = direction

	player.velocity = direction * player.character_info.run_speed

	animation_tree["parameters/Move/blend_position"] = direction
	animation_tree["parameters/Dash/blend_position"] = direction
	
	if is_equal_approx(direction.x, 0.0) and is_equal_approx(direction.y, 0.0):
		SignalBus.disconnect("starts_talking", starts_talking_run)
		SignalBus.disconnect("starts_fighting", get_caught_running)
		animation_tree["parameters/Move/blend_position"] = last_facing_direction
		animation_tree["parameters/conditions/move"] = false
		finished.emit(IDLE, {"last_facing_direction":last_facing_direction})
	
	player.move_and_slide()

func changing_scene_run() -> void:
	is_changing_scene = true

func starts_talking_run() -> void:
	if is_changing_scene:
		print("Scene is changing, cannot start talking.")
		return
	SignalBus.disconnect("starts_talking", starts_talking_run)
	SignalBus.disconnect("starts_fighting", get_caught_running)
	finished.emit(TALKING, {"last_facing_direction": animation_tree["parameters/Move/blend_position"]})

func get_caught_running() -> void:
	if SignalBus.is_connected("starts_talking", starts_talking_run):
		SignalBus.disconnect("starts_talking", starts_talking_run)
	SignalBus.disconnect("starts_fighting", get_caught_running)
	finished.emit(CAUGHT, {"last_facing_direction": animation_tree["parameters/Idle/blend_position"]})
