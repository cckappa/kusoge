extends Node2D
class_name AbilityAnimation

signal landed_ability()

@onready var animation_player:AnimationPlayer=$AnimationPlayer

func _ready() -> void:
	z_index = 15
	z_as_relative = false
	add_to_group("ability_animations")

func emit_lands_ability() -> void:
	emit_signal("landed_ability")
	modulate = Color(18.892, 18.892, 18.892)
	await get_tree().create_timer(0.2).timeout
	modulate = Color(1,1,1)
	await animation_player.animation_finished
	queue_free()