extends Node

func get_decimal(val:float) -> float:
	val = val * 0.1
	val = linear_to_db(val)
	return val
