extends TextureRect

const LEFT_ARROW = preload("res://assets/icons/left_arrow.png")
const TOP_ARROW = preload("res://assets/icons/top_arrow.png")
const RIGHT_ARROW = preload("res://assets/icons/right_arrow.png")
const BOTTOM_ARROW = preload("res://assets/icons/bottom_arrow.png")
const A_KEY = preload("res://assets/icons/a_key.png")
const S_KEY = preload("res://assets/icons/s_key.png")
const X_KEY = preload("res://assets/icons/x_key.png")
const Z_KEY = preload("res://assets/icons/z_key.png")


func select_arrow(pos: int, type: String) -> void:
	if type == "ally":
		match pos:
			0:
				texture = LEFT_ARROW
			1:
				texture = TOP_ARROW
			2:
				texture = RIGHT_ARROW
			3:
				texture = BOTTOM_ARROW
	elif  type == "enemy":
		match pos:
			0:
				texture = X_KEY
			1:
				texture = Z_KEY
			2:
				texture = A_KEY
			3:
				texture = S_KEY
