extends VBoxContainer

@onready var favorite_container := %FavoriteContainer
@onready var contact_list := %ContactList
@onready var focused_character := %FocusedCharacter

const FAVORITE_MEMBER := preload("res://scenes/favorite_member.tscn")
const FRIEND_BUTTON = preload("res://scenes/friend_button.tscn")

var switch_status:={
	"click_number":0,
	"from":{
		"position":null,
		"index":null
	},
	"to":{
		"position":null,
		"index":null
	}
}
var current_favorites:Array[StringName]

func _ready() -> void:
	var fav_index := 0
	for character in Globals.current_characters:
		var favorite_instance := FAVORITE_MEMBER.instantiate()
		favorite_instance.connect("focused", set_bigger_info.bind(character))
		favorite_instance.connect("pressed", switch_character_favorite.bind(fav_index))
		favorite_container.add_child(favorite_instance)
		favorite_instance.set_info(character)
		current_favorites.append(character.name)
		fav_index += 1
	
	var friend_index := 0
	for character in Globals.party:
		if current_favorites.has(character.name):
			pass
		else:
			var friend_instance := FRIEND_BUTTON.instantiate()
			friend_instance.text = character.name
			friend_instance.connect("focused", set_bigger_info.bind(character))
			friend_instance.connect("pressed_button", switch_character_friend.bind(friend_index))
			contact_list.add_child(friend_instance)
		friend_index += 1

func set_bigger_info(character:Character) -> void:
	focused_character.find_child("TextureRect").texture = character.character_portrait
	focused_character.find_child("RichTextLabel").text = character.name

func switch_character_favorite(index:int) -> void:
	if switch_status.click_number == 0:
		switch_status.from.position = "FAVORITE"
		switch_status.from.index = index
		switch_status.click_number = 1
	elif switch_status.click_number == 1:
		switch_status.to.position = "FAVORITE"
		switch_status.to.index = index
		if switch_status.from.position == "FAVORITE" and switch_status.from.index != switch_status.to.index:
			Globals.switch_favorite_places(switch_status.from.index, switch_status.to.index)
			reset_favorites()
		elif switch_status.from.position == "FRIEND":
			Globals.switch_friend_to_favorite(switch_status.from.index, switch_status.to.index)
			reset_favorites()
			reset_friends()
		clear_status()

func switch_character_friend(index:int) -> void:
	if switch_status.click_number == 0:
		switch_status.from.position = "FRIEND"
		switch_status.from.index = index
		switch_status.click_number = 1
	elif switch_status.click_number == 1:
		switch_status.to.position = "FRIEND"
		switch_status.to.index = index
		if switch_status.from.position == "FRIEND":
			pass
		elif switch_status.from.position == "FAVORITE":
			Globals.switch_favorite_to_friend(switch_status.from.index, switch_status.to.index)
			reset_favorites()
			reset_friends(true)

		clear_status()

func reset_favorites() -> void:
	current_favorites = []
	var index := 0
	for favorite in favorite_container.get_children():
		favorite.queue_free()
	
	for character in Globals.current_characters:
		var favorite_instance := FAVORITE_MEMBER.instantiate()
		favorite_instance.connect("focused", set_bigger_info.bind(character))
		favorite_instance.connect("pressed", switch_character_favorite.bind(index))
		favorite_container.add_child(favorite_instance)
		favorite_instance.set_info(character)
		if index == switch_status.to.index:
			favorite_instance.focus()
		
		current_favorites.append(character.name)
		index += 1

func reset_friends(focus:bool=false) -> void:
	var friend_index := 0
	for friend in contact_list.get_children():
		friend.queue_free()
		
	for character in Globals.party:
		if current_favorites.has(character.name):
			pass
		else:
			var friend_instance := FRIEND_BUTTON.instantiate()
			friend_instance.text = character.name
			friend_instance.connect("focused", set_bigger_info.bind(character))
			friend_instance.connect("pressed_button", switch_character_friend.bind(friend_index))
			contact_list.add_child(friend_instance)
			if focus and friend_index == switch_status.to.index:
				friend_instance.grab_focus()
		friend_index += 1

func clear_status() -> void:
	switch_status = {
		"click_number":0,
		"from":{
			"position":null,
			"index":null
		},
		"to":{
			"position":null,
			"index":null
		}
	}
