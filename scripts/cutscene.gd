class_name Cutscene
extends Control

@export var scene_changer:SceneChanger
@export var animation_player:AnimationPlayer
@export var animation_name:String="play"

func _ready() -> void:
	animation_player.play(animation_name)
	animation_player.connect("animation_finished", _on_animation_finished)

func _on_animation_finished(anim_name:String) -> void:
	if scene_changer.target_scene != "":
		scene_changer.emit_signal("change_scene_trigger")