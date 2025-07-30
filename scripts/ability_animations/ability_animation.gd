extends Node2D
class_name AbilityAnimation

signal landed_ability()

func _ready() -> void:
    z_index = 15
    z_as_relative = false

func emit_lands_ability() -> void:
    emit_signal("landed_ability")
    await get_tree().create_timer(0.2).timeout
    queue_free()