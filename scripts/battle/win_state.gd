extends LimboState

@onready var animation_player:=$VictoryKio/AnimationPlayer
@onready var victory_button:=$VictoryKio/Button
@onready var black_rect:=%BlackRect
@onready var audio_stream_player := %AudioStreamPlayer

var is_tkio_finished:=false
var is_tkio_hidden:=false
var finishing:= false

func _enter() -> void:
	victory_button.grab_focus()
	Globals.apply_stakes()
	audio_stream_player.set("parameters/switch_to_clip", "VictoryFanfare")
	animation_player.play("kio_victory")

func tkio_finished() -> void:
	is_tkio_finished = true

func tkio_hidden() -> void:
	is_tkio_hidden = true

func _on_button_pressed() -> void:
	if is_active() and is_tkio_finished and not finishing:
		animation_player.play("hide_kio")
		finishing = true

func _exit_battle() -> void:
	await Functions.fade_color_rect(black_rect, "IN", 2)
	get_tree().change_scene_to_file(Globals.current_map_path)
