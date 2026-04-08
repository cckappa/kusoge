class_name GrayBox
extends Node2D

# @export var invisible: bool = false

# @onready var static_body: StaticBody2D = $StaticBody2D

# func _ready() -> void:
# 	set_invisible(invisible)

# func set_invisible(value: bool) -> void:
# 	invisible = value
# 	visible = not invisible
# 	for child in static_body.get_children():
# 		if child is CollisionShape2D or child is CollisionPolygon2D:
# 			child.disabled = invisible
# 	for child in get_children():
# 		if child is Talk:
# 			child.disabled = invisible



