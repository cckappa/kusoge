extends RichTextLabel

func _ready() -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.hex(0xffffff00), 1)
	await tween.finished
	queue_free()
