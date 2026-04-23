extends LimboState

@onready var continue_button:Button=%ContinueButton
@onready var quit_button:Button=%QuitButton
@onready var lose_animation_player:AnimationPlayer=%LoseAnimationPlayer
@onready var black_rect:=%BlackRect
@onready var audio_stream_player := %AudioStreamPlayer

var option_selected:=false

func _enter() -> void:
	continue_button.grab_focus()
	audio_stream_player.set("parameters/switch_to_clip", "LostBattle")
	lose_animation_player.play("lose_screen")

func _on_continue_button_pressed() -> void:
	if is_active() and not option_selected:
		option_selected = true
		Globals.set_otk()
		await Functions.fade_color_rect(black_rect, "IN", 2)
		get_tree().change_scene_to_file(Globals.current_map_path)

func _on_quit_button_pressed() -> void:
	if is_active() and not option_selected:
		option_selected = true
		Globals.set_otk()
		await Functions.fade_color_rect(black_rect, "IN", 2)
		get_tree().change_scene_to_file("res://scenes/inicio_menu.tscn")

func _grab_focus() -> void:
	if not option_selected and is_active():
		if continue_button.has_focus():
			continue_button.grab_focus()
		elif quit_button.has_focus():
			quit_button.grab_focus()
		else:
			continue_button.grab_focus()