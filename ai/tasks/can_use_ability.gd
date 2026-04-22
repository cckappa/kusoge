extends BTAction

func _tick(_delta: float) -> Status:
	if not agent.can_use_ability():
		return SUCCESS
	else:
		return FAILURE
