extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	animation_tree["parameters/conditions/idle"] = true
	animation_tree["parameters/conditions/move"] = false
	animation_tree["parameters/Idle/blend_position"] = data["last_facing_direction"]
	if !SignalBus.is_connected("finishes_fighting", to_idle):
		SignalBus.connect("finishes_fighting", to_idle)
	print('entra caught')

func to_idle() -> void:
	SignalBus.disconnect("finishes_fighting", to_idle)
	finished.emit(IDLE, {"last_facing_direction": animation_tree["parameters/Idle/blend_position"]})
