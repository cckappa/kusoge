extends LimboState

@onready var black_rect:=%BlackRect

func _setup() -> void:
	black_rect.visible = true
	Functions.fade_color_rect(black_rect, "OUT", 2)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "battle_start" and is_active():
		dispatch("to_focus_party")
