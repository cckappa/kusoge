extends LimboState

func _setup() -> void:
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "battle_start" and is_active():
		dispatch("to_focus_party")
