extends Control

@onready var selected_button:TextureButton=%SelectedButton
@onready var character_texture:TextureRect=%CharacterTexture
@onready var info_vida_text:RichTextLabel=%InfoVidaText
@onready var vida_progress_bar:TextureProgressBar=%VidaProgressBar
@onready var texture_progress_bar:TextureProgressBar=%CooldownProgressBar

var party_character:Character

func set_info(_character:Character) -> void:
	party_character = _character
	name = party_character.identifier
	character_texture.texture = party_character.character_portrait
	info_vida_text.text = '[center]'+str(party_character.current_hp)

func focus_party_character() -> void:
	selected_button.grab_focus()

func _on_selected_button_pressed() -> void:
	SignalBus.emit_signal("party_character_button_pressed", party_character)
