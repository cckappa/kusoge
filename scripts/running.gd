extends PlayerState
# Extiende el playerstate nada mas para que sea mas facil jalar el playable character y sus variables

var last_facing_direction := Vector2(0,-1)

func enter(previous_state_path: String, data := {}) -> void:
	animation_tree.set("parameters/condition/move", true)
	print('entra running')

func physics_update(_delta: float) -> void:
	var direction := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

	if direction.length() > 1.0:
		direction = direction.normalized()
		last_facing_direction = player.velocity.normalized()

	player.velocity = direction * player.character_info.run_speed


	if is_equal_approx(direction.x, 0.0) and is_equal_approx(direction.y, 0.0):
		animation_tree.set("parameters/condition/move", false)
		finished.emit(IDLE, {"last_facing_direction":last_facing_direction})
	
	player.move_and_slide()
