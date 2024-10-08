extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.x = 0.0
	player.velocity.y = 0.0
	
	animation_tree.set("parameters/condition/idle", true)
	print('entra idle')

func physics_update(_delta: float) -> void:
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down"):
		animation_tree.set("parameters/condition/idle", false)
		finished.emit(RUNNING)
