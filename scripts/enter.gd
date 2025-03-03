extends BattleState

@export var character_portraits:HBoxContainer
@export var ally_container_preload := preload("res://scenes/ally_container.tscn")

var character_containers : Array[CharacterContainer]
var character_container_size := Vector2(125, 0)

func enter(previous_state_path: String, data := {}) -> void:
	pass
	#set_current_characters()
	#shuffle_character_abilities()
	#add_characters()
	#black_rect.visible = true
#
	#await Functions.fade_color_rect(black_rect, "OUT", 2)
	#finished.emit(DECIDING)

func set_current_characters() -> void:
	# Setea el orden del arrange
	Globals.current_arrange.left = Globals.party[0]
	Globals.current_arrange_allies.left = Globals.party[0]
	
	if Globals.party.size() > 1 and Globals.party[1] != null:
		Globals.current_arrange.up = Globals.party[1]
		Globals.current_arrange_allies.up = Globals.party[1]
	if Globals.party.size() > 2 and Globals.party[2] != null:
		Globals.current_arrange.right = Globals.party[2]
		Globals.current_arrange_allies.right = Globals.party[2]
	if Globals.party.size() > 3 and Globals.party[3] != null:
		Globals.current_arrange.down = Globals.party[3]
		Globals.current_arrange_allies.down = Globals.party[3]


func shuffle_character_abilities() -> void:
	for ally:Character in Globals.current_arrange_allies.values():
		if ally != null:
			shuffle_abilities(ally)

func add_characters() -> void:
	var key : int = 0
	for character:Character in Globals.current_arrange_allies.values():
		if character != null:
		# CharacterContainer
			var character_container := ally_container_preload.instantiate()
			character_container.name = character.name
			character_container.character = character
			character_container.max_hp = character.max_hp
			character_container.current_hp = character.current_hp
			character_container.size = character_container_size
			character_container.front_texture = character.character_front
			character_container.character_portrait = character.character_portrait
			character_container.arrange_position = key
			character_portraits.add_child(character_container)
			character_container.set_max_life(character.current_hp)
			character.current_container = character_container
			character.current_container.next_ability(character.current_abilities[1])
			key = key + 1

func shuffle_abilities(member:Character) -> void:
	member.current_abilities = member.abilities.duplicate(true)
	member.current_abilities.shuffle()
	member.current_abilities = member.current_abilities.slice(0, 2)
