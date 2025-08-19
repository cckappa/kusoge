@tool
extends Node

func _get_configuration_warnings() -> PackedStringArray:
	return PackedStringArray([
		"Add follow_target -> PlayableCharacter to PhantomCamera.",
		"Add limit_target -> AreasLimits/CameraLimit/CameraCollision to PhantomCamera.",
	])