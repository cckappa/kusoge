extends PlayerState
# Extiende el playerstate nada mas para que sea mas facil jalar el playable character y sus variables

func enter(previous_state_path: String, data := {}) -> void:
	animation_tree["parameters/conditions/move"] = true
	SignalBus.connect("starts_talking", starts_talking_run)
	if !SignalBus.is_connected("starts_fighting", get_caught_running):
		SignalBus.connect("starts_fighting", get_caught_running)
	print('entra running')

func physics_update(_delta: float) -> void:
	direction = Vector2( 
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

	if direction.length() > 1.0:
		direction = direction.normalized()
	
	if direction != Vector2.ZERO:
		last_facing_direction = direction

	player.velocity = direction * player.character_info.run_speed

	animation_tree["parameters/Move/blend_position"] = direction
	animation_tree["parameters/Dash/blend_position"] = direction
	
	if is_equal_approx(direction.x, 0.0) and is_equal_approx(direction.y, 0.0):
		animation_tree["parameters/conditions/move"] = false
		SignalBus.disconnect("starts_talking", starts_talking_run)
		SignalBus.disconnect("starts_fighting", get_caught_running)
		finished.emit(IDLE, {"last_facing_direction":last_facing_direction})
	
	player.move_and_slide()

func handle_input(event:InputEvent) -> void:
	if event.is_action_pressed("dash") and can_dash:
		can_dash = false
		emit_signal("dash_cooldown")
		SignalBus.disconnect("starts_talking", starts_talking_run)
		SignalBus.disconnect("starts_fighting", get_caught_running)
		animation_tree["parameters/conditions/move"] = false
		finished.emit(DASHING, {"last_facing_direction":last_facing_direction})

func starts_talking_run() -> void:
	SignalBus.disconnect("starts_talking", starts_talking_run)
	SignalBus.disconnect("starts_fighting", get_caught_running)
	finished.emit(TALKING, {"last_facing_direction": animation_tree["parameters/Move/blend_position"]})

func get_caught_running() -> void:
	if SignalBus.is_connected("starts_talking", starts_talking_run):
		SignalBus.disconnect("starts_talking", starts_talking_run)
	SignalBus.disconnect("starts_fighting", get_caught_running)
	finished.emit(CAUGHT, {"last_facing_direction": animation_tree["parameters/Idle/blend_position"]})
