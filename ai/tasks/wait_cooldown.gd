extends BTAction

var _elapsed: float = 0.0

func _enter() -> void:
	_elapsed = 0.0

func _tick(delta: float) -> Status:
	_elapsed += delta
	if _elapsed >= agent.current_ability.wait_time:
		return SUCCESS
	return RUNNING
