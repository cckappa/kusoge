class_name CharacterContainer
extends VBoxContainer

signal focused_character(character:Character, container:CharacterContainer)
signal unfocused_character(character:Character, container:CharacterContainer)

var front_texture : Texture
var character : Character

func _ready() -> void:
	connect("mouse_entered", focused)
	connect("focus_entered", focused)
	connect("mouse_exited", unfocused)
	connect("focus_exited", unfocused)

func focused() -> void:
	#get_child(0).custom_minimum_size = Vector2(200, 300)
	emit_signal("focused_character", character, self)

func unfocused() -> void:
	emit_signal("unfocused_character", character, self)
	
	#get_child(0).custom_minimum_size = Vector2(0, 0)
