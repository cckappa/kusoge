extends Control

@onready var animation_player:AnimationPlayer=$AnimationPlayer

signal intro_screen_finished

func _ready() -> void:
	animation_player.connect("animation_finished", _on_animation_finished)

func _on_animation_finished(anim_name: String) -> void:
	emit_signal("intro_screen_finished")
	queue_free()