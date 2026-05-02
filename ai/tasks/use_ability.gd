extends BTAction

func _tick(_delta: float) -> Status:
	agent.use_ability()
	return SUCCESS
