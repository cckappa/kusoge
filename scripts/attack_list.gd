extends VBoxContainer

@onready var character_portraits := %CharacterPortraits

func _ready() -> void:
	for character_portrait in character_portraits.get_children():
		character_portrait.connect("focused_character", set_focused)

func set_focused(character:Character) -> void:
	var abilities_description:=""

	for ability in character.abilities:
		match ability.type:
			"Attack" :
				var description := "\n{0}\n{1}\n{2}\n"
				description = description.format([ability.ability_name, ability.damage_points, ability.description]) + Functions.array_to_string(ability.sequence, ", ")
				abilities_description += description
			"Heal" :
				var description := "\n{0}\n{1}\n{2}\n"
				description = description.format([ability.ability_name, ability.heal_points, ability.description]) + Functions.array_to_string(ability.sequence, ", ")
				abilities_description += description
	
	get_child(0).text = abilities_description
	
