extends Button

signal focused()
signal pressed_button()

func _on_pressed() -> void:
	emit_signal("pressed_button")

func _on_focus_entered() -> void:
	emit_signal("focused")
