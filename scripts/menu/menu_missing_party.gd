extends MarginContainer
@export var color_focus:Color
@export var color_unfocus:Color

@onready var background_color:=%BackgroundColor

func _on_focus_entered() -> void:
	var tween := create_tween().bind_node(self).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(background_color, "color", color_focus, 0.1)

func _on_focus_exited() -> void:
	var tween := create_tween().bind_node(self).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(background_color, "color", color_unfocus, 0.1)

func _on_button_pressed() -> void:
	pass
