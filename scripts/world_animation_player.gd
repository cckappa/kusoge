extends AnimationPlayer
class_name WorldAnimationPlayer

func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	SignalBus.connect("play_world_animation", _on_play_world_animation)

func _on_dialogic_signal(argument:Dictionary) -> void:
	if not argument.has("animation"):
		print("Dialogic signal received without 'animation' key:", argument)
		return

	var event_name :String = argument.animation
	print("Dialogic text signal received:", event_name)
	if has_animation(event_name):
		play(event_name)

func _on_play_world_animation(event_name: String) -> void:
	print("Play world animation signal received:", event_name)
	if has_animation(event_name):
		play(event_name)
