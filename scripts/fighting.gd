extends BattleState

@export var active_character:HBoxContainer
@export var active_character_buttons:VBoxContainer
@export var attack:Button
@export var menu:Button
@export var character_portraits:HBoxContainer
@export var attack_list:VBoxContainer

var active_attacker:Character

func enter(previous_state_path: String, data := {}) -> void:
	active_attacker = Globals.party[0]
	active_character.visible = true
	attack.connect("pressed", start_attacking)
	connect_portraits()

func connect_portraits() -> void:
	for character_portrait in character_portraits.get_children():
		character_portrait.connect("focused_character", set_focused)
		character_portrait.connect("unfocused_character", set_unfocused)

func disconnect_portraits() -> void:
	for character_portrait in character_portraits.get_children():
		character_portrait.disconnect("focused_character", set_focused)
		character_portrait.disconnect("unfocused_character", set_unfocused)
	
func start_attacking() -> void:
	attack.disconnect("pressed", start_attacking)
	active_character_buttons.visible = false
	disconnect_portraits()
	finished.emit(ATTACKING, {"character": active_attacker})

func start_menu() -> void:
	pass

func set_focused(character:Character, container:CharacterContainer) -> void:
	active_attacker = character
	active_character.get_child(0).texture = character.character_front
	container.get_child(0).custom_minimum_size = Vector2(200, 300)
	#list_abilities(character)


func set_unfocused(character:Character, container:CharacterContainer) -> void:
	container.get_child(0).custom_minimum_size = Vector2(0, 0)

#func list_abilities(character:Character) -> void:
	#var abilities_description:=""
#
	#for ability in character.abilities:
		#match ability.type:
			#"Attack" :
				#var description := "\n{0}\n{1}\n{2}\n"
				#description = description.format([ability.ability_name, ability.damage_points, ability.description]) + Functions.array_to_string(ability.sequence, ", ")
				#abilities_description += description
			#"Heal" :
				#var description := "\n{0}\n{1}\n{2}\n"
				#description = description.format([ability.ability_name, ability.heal_points, ability.description]) + Functions.array_to_string(ability.sequence, ", ")
				#abilities_description += description
	#
	#attack_list.get_child(0).text = abilities_description
