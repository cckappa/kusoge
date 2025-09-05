extends Control

signal victory_finished_hiding()

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var is_hidden := false
var finished_animation := false

func play_victory_animation() -> void:
	animation_player.play("kio_victory")
	await animation_player.animation_finished
	finished_animation = true

func play_hide_animation() -> void:
	if not is_hidden and finished_animation:
		animation_player.play("hide_kio")
		is_hidden = true
		await animation_player.animation_finished
		emit_signal("victory_finished_hiding")