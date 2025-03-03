extends Button

signal focused()

func _on_pressed() -> void:
	pass # Replace with function body.


func _on_focus_entered() -> void:
	emit_signal("focused")
