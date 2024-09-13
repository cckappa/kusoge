extends Control

@export_category('Top Menu')
@export var game_button:Button
@export var accesibility_button:Button
@export var audio_button:Button
@export var controls_button:Button
@export var video_button:Button

@export_category('Panels')
@export var game_panel:PanelContainer
@export var accesibility_panel:PanelContainer
@export var audio_panel:PanelContainer
@export var controls_panel:PanelContainer
@export var video_panel:PanelContainer

@export_category('Bottom Buttons')
@export var close_button:Button

var paneles:Array[PanelContainer]

func _ready() -> void:
	game_button.connect("pressed", pressed_game)
	accesibility_button.connect("pressed", pressed_accesibility)
	audio_button.connect("pressed", pressed_audio)
	controls_button.connect("pressed", pressed_controls)
	video_button.connect("pressed", pressed_video)
	close_button.connect("pressed", save_changes)
	paneles = [game_panel, accesibility_panel, audio_panel, controls_panel, video_panel]

func _input(event:InputEvent) -> void:
	pass
	#if event.is_action_pressed("pause"):
		#if(visible == true):
			#save_changes()
		#else:
			#toggle_pause()


func pressed_game() -> void:
	game_button.button_pressed = true
	toggle_panels(game_panel)

func pressed_accesibility() -> void:
	accesibility_button.button_pressed = true
	toggle_panels(accesibility_panel)

func pressed_audio() -> void:
	audio_button.button_pressed = true
	toggle_panels(audio_panel)

func pressed_controls() -> void:
	controls_button.button_pressed = true
	toggle_panels(controls_panel)

func pressed_video() -> void:
	video_button.button_pressed = true
	toggle_panels(video_panel)

func toggle_panels(selected_panel:PanelContainer) -> void:
	for panel in paneles:
		panel.visible = false
	selected_panel.visible = true

func toggle_pause() -> void:
	get_tree().paused = true
	visible = true

func discard_changes() -> void:
	SignalBus.emit_signal("settings_discarded")
	get_tree().paused = false
	visible = false

func save_changes() -> void:
	ConfigFileHandler.save_settings_to_file()
	get_tree().paused = false
	visible = false
