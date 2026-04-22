extends MarginContainer

@export var color_focus:Color
@export var color_unfocus:Color

@onready var background_color:=%BackgroundColor
@onready var member_profile:TextureRect= %MemberProfile

enum button_type {
	PARTY,
	MEMBER
}

var type := button_type.PARTY

var character:Character

func setup_info(_character:Character) -> void:
	character = _character
	member_profile.texture = _character.character_portrait
	if not _character.unlocked:
		member_profile.modulate = Color(0,0,0,1)
	else:
		member_profile.modulate = Color(1,1,1,1)
	background_color.color = color_unfocus

func _on_focus_entered() -> void:
	SignalBus.emit_signal("menu_party_character_focus_entered", character)
	var tween := create_tween().bind_node(self).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(background_color, "color", color_focus, 0.1)

func _on_focus_exited() -> void:
	var tween := create_tween().bind_node(self).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(background_color, "color", color_unfocus, 0.1)

func _on_button_pressed() -> void:
	if type == button_type.PARTY:
		print("Party con: ", character.name)
		SignalBus.emit_signal("menu_party_character_button_pressed", character)
	elif type == button_type.MEMBER and character.unlocked:
		print("Member: ", character.name)
		SignalBus.emit_signal("menu_member_character_button_pressed", character)
