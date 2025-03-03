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
	
	var serialized_items := {}
	for identifier:StringName in Items.item_list:
		var item_data :Dictionary= Items.item_list[identifier]
		serialized_items[identifier] = {
			"resource_path": item_data.resource.resource_path,  # Store path instead of resource
			"total": item_data.total
		}
	
	var serialized_current_characters:Array[Dictionary]
	for character in Globals.current_characters:
		var character_data := {
			"resource_path": character.resource_path,   # Save the resource path
			"current_hp": character.current_hp           # Save dynamic property (current_hp)
		}
		serialized_current_characters.append(character_data)
	
	var serialized_party:Array[Dictionary]
	for character in Globals.party:
		var character_data := {
			"resource_path": character.resource_path,   # Save the resource path
			"current_hp": character.current_hp           # Save dynamic property (current_hp)
		}
		serialized_party.append(character_data)
	
	var data:={
		"player": {
			"position":{
				"x": Globals.player_position.x,
				"y": Globals.player_position.y
			}
		},
		"items": serialized_items,
		"current_characters": serialized_current_characters,
		"party": serialized_party
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
		current_characters.append(character_resource)

	var party:Array[Character]
	for character:Dictionary in data.party:
		var character_resource := load(character.resource_path)
		character_resource.set_current_hp(character.current_hp)
		party.append(character_resource)
		
	Globals.current_characters = current_characters
	Globals.party = party
