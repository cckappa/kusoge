extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	animation_tree["parameters/conditions/idle"] = true
	animation_tree["parameters/conditions/move"] = false
	animation_tree["parameters/Idle/blend_position"] = data["last_facing_direction"]
	SignalBus.connect("stops_talking", stops_talking)
	print('entra talking')

func stops_talking() -> void:
	SignalBus.disconnect("stops_talking", stops_talking)
	finished.emit(IDLE, {"last_facing_direction": animation_tree["parameters/Idle/blend_position"]})
