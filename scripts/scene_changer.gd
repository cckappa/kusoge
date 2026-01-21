extends Area2D
class_name SceneChanger

@export var target_scene: String
@export var target_marker: String
@export var black_rect: ColorRect

signal change_scene_trigger()

var change_scene:PackedScene
var change_in_progress: bool = false

func _ready() -> void:
	print("SceneChanger: Ready to change scene to:", target_scene)
	connect("body_entered", _on_body_entered)
	connect("change_scene_trigger", _on_change_scene_trigger)

func _on_body_entered(body:Node2D) -> void:
	if body.is_in_group("main_character") and !change_in_progress:
		change_scene_to_target(body)

func _on_change_scene_trigger() -> void:
	if !change_in_progress:
		change_scene_to_target(null)

func change_scene_to_target(body:Node2D) -> void:
	change_in_progress = true
	SignalBus.emit_signal("changing_scene")
	Globals.from_door = true
	Globals.target_marker = target_marker
	black_rect.visible = true
	await Functions.fade_color_rect(black_rect, "IN", 0.5)
	get_tree().change_scene_to_file(target_scene)
	disconnect("body_entered", _on_body_entered)

