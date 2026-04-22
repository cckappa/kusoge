extends LimboState

@onready var animation_player:=$VictoryKio/AnimationPlayer
@onready var victory_button:=$VictoryKio/Button

var is_tkio_finished:=false
var is_tkio_hidden:=false
var finishing:= false

func _enter() -> void:
	victory_button.grab_focus()
	animation_player.play("kio_victory")

func tkio_finished() -> void:
	is_tkio_finished = true

func tkio_hidden() -> void:
	is_tkio_hidden = true

func _on_button_pressed() -> void:
	if is_active() and is_tkio_finished and not finishing:
		animation_player.play("hide_kio")
		finishing = true
	elif is_active() and is_tkio_finished and is_tkio_hidden:
		print("GANAS")
