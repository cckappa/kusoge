extends PanelContainer

signal focused()
signal pressed()

@onready var selected_button := $SelectedButton
@onready var texture_rect := %TextureRect
@onready var rich_text_label := %RichTextLabel

var character_name:StringName

func set_info(character:Character) -> void:
	character_name = character.name
	rich_text_label.text = character.name
	texture_rect.texture = character.character_portrait

func _on_selected_button_focus_entered() -> void:
	emit_signal("focused")

func _on_selected_button_pressed() -> void:
	emit_signal("pressed")

func release_pressed() -> void:
	selected_button.button_pressed = false

func focus() -> void:
	selected_button.grab_focus()
