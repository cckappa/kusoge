extends Control

@export var black_rect : ColorRect
var can_continue : bool = false

func _ready() -> void:
	black_rect.visible = true
	await Functions.fade_color_rect(black_rect, "OUT", 2)
	await get_tree().create_timer(10).timeout
	can_continue = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and can_continue:
		can_continue = false
		black_rect.visible = true
		await Functions.fade_color_rect(black_rect, "IN", 2)
		get_tree().change_scene_to_file("res://scenes/inicio_menu.tscn")
