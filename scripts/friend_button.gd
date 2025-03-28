extends Button

signal focused()
signal pressed_button()

var character:Character


func set_info(_character:Character) -> void:
	character = _character
	if character.unlocked:
		text = character.name
	else:
		text = "???"

func _on_pressed() -> void:
	if character.unlocked:
		emit_signal("pressed_button")

func _on_focus_entered() -> void:
	emit_signal("focused")
