extends PanelContainer

signal pressed_character_item(characters:Array[Character])

@onready var character_portrait := %CharacterPortrait
@onready var character_name := %CharacterName
@onready var character_hp := %CharacterHp
@onready var selected_button := %SelectedButton

var character:Character

func _ready() -> void:
	set_info()

func set_info() -> void:
	if character != null:
		character_name.text = character.name
		character_hp.text = str(character.current_hp) + "/" + str(character.max_hp)
		character_portrait.texture = character.character_portrait
	else:
		character_name.text = ""
		character_hp.text = ""
		character_portrait.texture = null

func focus() -> void:
	selected_button.grab_focus()

func set_focus() -> void:
	selected_button.focus_mode = Control.FOCUS_ALL

func unfocus() -> void:
	selected_button.focus_mode = Control.FOCUS_NONE

func _on_selected_button_pressed() -> void:
	var char_array :Array[Character]= [character]
	emit_signal("pressed_character_item", char_array)