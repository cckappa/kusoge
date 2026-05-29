extends MarginContainer

@export var color_focus: Color
@export var color_unfocus: Color

@onready var background_color := %BackgroundColor
@onready var member_profile: TextureRect = %MemberProfile
@onready var switch_control: Control = %SwitchControl
@onready var switch_button: Button = %SwitchButton
@onready var switch_profile: TextureRect = %SwitchProfile
@onready var first_button: Button = $Button

var character: Character
var id: int

func setup_info(_character: Character, _id: int = -1) -> void:
	if _character == null:
		remove_info()
		if _id != -1:
			id = _id
		background_color.color = color_unfocus
		return

	character = _character

	if _id != -1:
		id = _id
	else:
		id = _character.character_id

	member_profile.texture = _character.character_portrait
	if not _character.unlocked:
		member_profile.modulate = Color(0, 0, 0, 1)
	else:
		member_profile.modulate = Color(1, 1, 1, 1)
	background_color.color = color_unfocus

func remove_info() -> void:
	character = null
	member_profile.texture = null

func focus_normal() -> void:
	switch_control.visible = false
	first_button.focus_mode = Control.FOCUS_ALL
	switch_button.focus_mode = Control.FOCUS_NONE

func set_new_character_id() -> void:
	if id != -1 and character != null:
		# print("Setting ID: ", character.character_id, " to ", id)
		character.character_id = id


func _on_focus_entered() -> void:
	SignalBus.emit_signal("menu_party_character_focus_entered", character)
	var tween := create_tween().bind_node(self ).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(background_color, "color", color_focus, 0.1)

func _on_focus_exited() -> void:
	var tween := create_tween().bind_node(self ).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(background_color, "color", color_unfocus, 0.1)

func _on_button_pressed() -> void:
	if character != null:
		print("Party con: ", character.name)
		SignalBus.emit_signal("menu_party_character_button_pressed", character, self )

func switch_focus() -> void:
	first_button.focus_mode = Control.FOCUS_NONE
	switch_button.focus_mode = Control.FOCUS_ALL

func set_switch_info(_character: Character) -> void:
	switch_profile.texture = _character.character_portrait

func show_portrait() -> void:
	member_profile.visible = true

func _on_switch_button_pressed() -> void:
	SignalBus.emit_signal("menu_party_switch_button_pressed", character, self )

func _on_switch_button_focus_entered() -> void:
	switch_control.visible = true

func _on_switch_button_focus_exited() -> void:
	switch_control.visible = false
