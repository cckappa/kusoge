extends BattleState

@export var character_portraits:HBoxContainer
@export var enemy_portraits:HBoxContainer
var ability:Ability
var target:Character

func enter(previous_state_path: String, data := {}) -> void:
	ability = data.ability
	connect_portraits()

func connect_portraits() -> void:
	for character_portrait in character_portraits.get_children():
		character_portrait.connect("focused_character", set_focused)
		character_portrait.connect("unfocused_character", set_unfocused)
		character_portrait.connect("pressed", set_target)

	for enemy_portrait in enemy_portraits.get_children():
		enemy_portrait.connect("focused_character", set_focused)
		enemy_portrait.connect("unfocused_character", set_unfocused)

func disconnect_portraits() -> void:
	for character_portrait in character_portraits.get_children():
		character_portrait.disconnect("focused_character", set_focused)
		character_portrait.disconnect("unfocused_character", set_unfocused)

	for enemy_portrait in enemy_portraits.get_children():
		enemy_portrait.disconnect("focused_character", set_focused)
		enemy_portrait.disconnect("unfocused_character", set_unfocused)

func set_focused(character:Character, container:Variant) -> void:
	container.get_child(0).custom_minimum_size = Vector2(200, 300)
	container.get_child(1).visible = true

func set_unfocused(character:Character, container:Variant) -> void:
	container.get_child(0).custom_minimum_size = Vector2(0, 0)
	container.get_child(1).visible = false

func set_target(character:Character, container:Variant) -> void:
	target = character
	finished.emit(RESOLVING,{"ability":ability, "target":target})
