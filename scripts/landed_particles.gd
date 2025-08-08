extends Node2D
class_name LandedParticles

@export var _z_index: int = 16

func _ready() -> void:
	z_index = _z_index
	z_as_relative = false
	
