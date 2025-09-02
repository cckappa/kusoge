extends Node

const SAVE_PATH = "user://saves/"
const SAVE_FILE_NAME = "save_file.json"
const SECURITY_KEY = "vTIO/te0x4Brl0EuGgnpY2xe8sE7bloWU1ZjCKllat23U4sU9p3PqXK31uV5wDm2"

func _ready() -> void:
	verify_save_directory(SAVE_PATH)

func verify_save_directory(path: String) -> void:
	DirAccess.make_dir_absolute(path)

func save_game(path:String = SAVE_PATH + SAVE_FILE_NAME) -> void:
	var file := FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, SECURITY_KEY)
		
	if file == null:
		print(FileAccess.get_open_error())
		return
	
	## SERIALIZE ITEMS
	var serialized_items := {}
	for identifier:StringName in Items.item_list:
		var item_data :Dictionary= Items.item_list[identifier]
		serialized_items[identifier] = {
			"resource_path": item_data.resource.resource_path,  # Store path instead of resource
			"total": item_data.total
		}
	
	## SERIALIZE CURRENT CHARACTERS
	var serialized_current_characters:Array[Dictionary]
	for character in Globals.current_characters:
		var character_data := {
			"resource_path": character.resource_path,   # Save the resource path
			"current_hp": character.current_hp,           # Save dynamic property (current_hp)
			"unlocked": character.unlocked
		}
		serialized_current_characters.append(character_data)
	
	## SERIALIZE PARTY
	var serialized_party:Array[Dictionary]
	for character in Globals.party:
		var character_data := {
			"resource_path": character.resource_path,   # Save the resource path
			"current_hp": character.current_hp,           # Save dynamic property (current_hp)
			"unlocked": character.unlocked
		}
		serialized_party.append(character_data)

	## SERIALIZE DIALOGIC VARIABLES
	var dialogic_variables:={}
	for quest_folder:Object in Dialogic.VAR.Quests.folders():		
		var folder_name :String = quest_folder.path
		
		dialogic_variables[folder_name] = {} 
		for variable:String in quest_folder.variables():
			dialogic_variables[folder_name][variable] = quest_folder.get(variable)

	## SERIALIZE QUESTS
	var serialized_quests:= {}
	for identifier:StringName in Quests.current_quests:  # Iterate over quest objects
		var quest_data:QuestResource = Quests.current_quests[identifier]
		serialized_quests[identifier] = {
			"resource_path": quest_data.resource_path,   # Save the resource path
			"quest_status": quest_data.quest_status,        # Include quest_status
			"quest_goal_index": quest_data.quest_goal_index  # Include quest_goal_index
		}
	
	var data:={
		"player": {
			"position":{
				"x": Globals.player_position.x,
				"y": Globals.player_position.y
			}
		},
		"maps": Globals.maps,
		"current_map": {
			"path": Globals.current_map_path,
		},
		"items": serialized_items,
		"current_characters": serialized_current_characters,
		"party": serialized_party,
		"dialogic_variables": dialogic_variables,
		"current_quests": serialized_quests,
		"key_variables": Globals.key_variables
	}
	
	var json_string := JSON.stringify(data, "\t")
	
	file.store_string(json_string)
	file.close()

func load_game(path:String = SAVE_PATH + SAVE_FILE_NAME) -> void:
	if FileAccess.file_exists(path):
		var file := FileAccess.open_encrypted_with_pass(path, FileAccess.READ, SECURITY_KEY)
		if file == null:
			print(FileAccess.get_open_error())
			return
		
		var content := file.get_as_text()
		file.close()
		
		var data:Dictionary = JSON.parse_string(content)
		if data == null:
			printerr("Cannot parse %s as a json_string: (%s)" % [path, content])
		
		set_game_info(data)
	else:
		printerr("Cannot open non-existent file at %s" % [path])

func set_game_info(data:Dictionary) -> void:
	## PLAYER INFO
	Globals.player_position = Vector2(data.player.position.x, data.player.position.y)
	
	## ITEM INFO
	Items.item_list.clear()
	for identifier:StringName in data.items:
		var item_data :Dictionary= data.items[identifier]
		var item_resource := load(item_data.resource_path)  # Load the Resource back
		if item_resource:
			Items.item_list[identifier] = {
				"resource": item_resource,
				"total": item_data.total
			}
	
	## CHARACTERS INFO
	var current_characters:Array[Character]
	for character:Dictionary in data.current_characters:
		var character_resource := load(character.resource_path)
		character_resource.set_current_hp(character.current_hp)
		character_resource.unlocked = character.unlocked
		current_characters.append(character_resource)

	var party:Array[Character]
	for character:Dictionary in data.party:
		var character_resource := load(character.resource_path)
		character_resource.set_current_hp(character.current_hp)
		character_resource.unlocked = character.unlocked
		party.append(character_resource)
		
	Globals.current_characters = current_characters
	Globals.party = party

	## DIALOGIC VARIABLES
	for folder_name:String in data.dialogic_variables:
		var result := folder_name.split(".")
		
		var folder:Object = Dialogic.VAR.Quests.get(result[1])
		for variable:String in data.dialogic_variables[folder_name]:
			folder.set(variable, data.dialogic_variables[folder_name][variable])

	## QUESTS
	Quests.current_quests.clear()

	for identifier: StringName in data.current_quests:
		var quest_data: Dictionary = data.current_quests[identifier]
		var quest_resource := load(quest_data.resource_path)  # Load the QuestResource using identifier

		if quest_resource:
			quest_resource.quest_status = quest_data.quest_status  # Set the quest status
			quest_resource.quest_goal_index = quest_data.quest_goal_index  # Set the quest status
			Quests.current_quests[identifier] = quest_resource  # Store in current quests

	## MAP
	Globals.maps = data.maps
	Globals.current_map_path = data.current_map.path

	## KEY VARIABLES
	Globals.key_variables = data.key_variables

func clear_save_file(path:String = SAVE_PATH + SAVE_FILE_NAME) -> void:
	if FileAccess.file_exists(path):
		var dir := DirAccess.open("res://")  # Base path doesn’t matter much for absolute paths
		if dir:
			var err := DirAccess.remove_absolute(path)
			if err == OK:
				print("Save file deleted successfully: ", path)
			else:
				printerr("Failed to delete save file: ", path, " Error code: ", err)
	else:
		print("No save file exists at: ", path)
