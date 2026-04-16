extends MarginContainer

@export var color_focus:Color
@export var color_unfocus:Color

@onready var background_color:=%BackgroundColor
@onready var member_profile:TextureRect= %MemberProfile

var character:Character

func setup_info(_character:Character) -> void:
	character = _character
	member_profile.texture = _character.character_portrait
	background_color.color = color_unfocus

func _on_focus_entered() -> void:
	SignalBus.emit_signal("menu_party_character_focus_entered", character)
	var tween := create_tween().bind_node(self).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(background_color, "color", color_focus, 0.1)

func _on_focus_exited() -> void:
	var tween := create_tween().bind_node(self).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(background_color, "color", color_unfocus, 0.1)
