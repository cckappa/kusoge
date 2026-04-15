extends TextureButton

@onready var panel_container: PanelContainer = $PanelContainer

var current_size: Vector2
var current_position: Vector2
var y_offset: float = 50
var min_scale: Vector2 = Vector2(0.7, 0.7)
var tween_time: float = 0.2

func _ready() -> void:
	panel_container.size = Vector2(0,0)
	current_size = panel_container.size
	current_position = panel_container.position
	panel_container.pivot_offset = Vector2(current_size.x/2, current_size.y/2)
	panel_container.scale = min_scale

func appear() -> void:
	var tween : Tween= create_tween()
	tween.tween_property(panel_container, "scale", Vector2(1, 1), tween_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(panel_container, "position", Vector2(current_position.x, current_position.y - y_offset), tween_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func disappear() -> void:
	var tween : Tween= create_tween()
	tween.tween_property(panel_container, "scale", min_scale, tween_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(panel_container, "position", Vector2(current_position.x, current_position.y), tween_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_focus_entered() -> void:
	appear()

func _on_focus_exited() -> void:
	disappear()
