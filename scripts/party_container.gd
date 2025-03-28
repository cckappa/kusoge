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
	SignalBus.connect("character_unlocked", character_unlocked)
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
			friend_instance.set_info(character)
			friend_instance.connect("focused", set_bigger_info.bind(character))
			friend_instance.connect("pressed_button", switch_character_friend.bind(friend_index))
			contact_list.add_child(friend_instance)
		friend_index += 1
	
	set_neighbours()


func set_bigger_info(character:Character) -> void:
	var texture_character := focused_character.find_child("TextureRect")
	texture_character.texture = character.character_portrait

	if character.unlocked:
		focused_character.find_child("RichTextLabel").text = character.name
		texture_character.self_modulate = Color(0xffffffff)
	else:
		focused_character.find_child("RichTextLabel").text = "???"
		texture_character.self_modulate = Color(0x060606ff)

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
			set_neighbours()
		elif switch_status.from.position == "FRIEND":
			Globals.switch_friend_to_favorite(switch_status.from.index, switch_status.to.index)
			reset_favorites()
			reset_friends()
			set_neighbours()
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
			set_neighbours()

		clear_status()

func reset_favorites() -> void:
	current_favorites = []
	var index := 0
	for favorite in favorite_container.get_children():
		favorite_container.remove_child(favorite)
		favorite.queue_free()
	
	for character in Globals.current_characters:
		var favorite_instance := FAVORITE_MEMBER.instantiate()
		favorite_instance.connect("focused", set_bigger_info.bind(character))
		favorite_instance.connect("pressed", switch_character_favorite.bind(index))
		favorite_container.add_child(favorite_instance)
		favorite_instance.set_info(character)
		if index == switch_status.to.index:
			# call_deferred("focus", favorite_instance)
			favorite_instance.focus()
		
		current_favorites.append(character.name)
		index += 1



func reset_friends(focus:bool=false) -> void:
	var friend_index := 0
	for friend in contact_list.get_children():
		contact_list.remove_child(friend)
		friend.queue_free()
		
	for character in Globals.party:
		if current_favorites.has(character.name):
			pass
		else:
			var friend_instance := FRIEND_BUTTON.instantiate()
			friend_instance.set_info(character)
			friend_instance.connect("focused", set_bigger_info.bind(character))
			friend_instance.connect("pressed_button", switch_character_friend.bind(friend_index))
			contact_list.add_child(friend_instance)
			if focus and friend_index == switch_status.to.index:
				# call_deferred("grab_focus", friend_instance)
				friend_instance.grab_focus()
		friend_index += 1
	

func set_neighbours() -> void:
	if favorite_container.get_child_count() > 0:
		for button in favorite_container.get_children():
			button.selected_button.focus_neighbor_top = NodePath("")
			button.selected_button.focus_neighbor_right = NodePath("")
			button.selected_button.focus_neighbor_left = NodePath("")
			button.selected_button.focus_neighbor_bottom = NodePath("")
	
	favorite_container.get_child(0).selected_button.focus_neighbor_right = favorite_container.get_child(1).selected_button.get_path()
	favorite_container.get_child(0).selected_button.focus_neighbor_left = favorite_container.get_child(3).selected_button.get_path()
	favorite_container.get_child(0).selected_button.focus_neighbor_bottom = contact_list.get_child(0).get_path()
	
	favorite_container.get_child(1).selected_button.focus_neighbor_right = favorite_container.get_child(2).selected_button.get_path()
	favorite_container.get_child(1).selected_button.focus_neighbor_left = favorite_container.get_child(0).selected_button.get_path()
	favorite_container.get_child(1).selected_button.focus_neighbor_bottom = contact_list.get_child(0).get_path()

	favorite_container.get_child(2).selected_button.focus_neighbor_right = favorite_container.get_child(3).selected_button.get_path()
	favorite_container.get_child(2).selected_button.focus_neighbor_left = favorite_container.get_child(1).selected_button.get_path()
	favorite_container.get_child(2).selected_button.focus_neighbor_bottom = contact_list.get_child(0).get_path()

	favorite_container.get_child(3).selected_button.focus_neighbor_right = favorite_container.get_child(0).selected_button.get_path()
	favorite_container.get_child(3).selected_button.focus_neighbor_left = favorite_container.get_child(2).selected_button.get_path()
	favorite_container.get_child(3).selected_button.focus_neighbor_bottom = contact_list.get_child(0).get_path()

	contact_list.get_child(0).focus_neighbor_top = favorite_container.get_child(0).selected_button.get_path()

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

func character_unlocked(_character:Character) -> void:
	reset_favorites()
	reset_friends()
	set_neighbours()
