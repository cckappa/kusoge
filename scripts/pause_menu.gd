extends Control

@onready var button_container := %ButtonContainer
@onready var party_container := %PartyContainer
@onready var items_container := %ItemsContainer
@onready var quests_container := %QuestsContainer
@onready var favorite_container := %FavoriteContainer
@onready var character_items_container := %CharacterItemsContainer
@onready var character_items_scroll := %CharacterItemsScroll
@onready var use_item := %UseItem
@onready var toss_item := %TossItem
@onready var back_item := %BackItem
@onready var items := %Items

const inicio_menu : PackedScene = preload("res://scenes/inicio_menu.tscn")

var on_dialogic:=false
var menu_level:=0
var quit_paused:=false

func _ready() -> void:
	SignalBus.connect("starts_talking", starts_talking)
	SignalBus.connect("stops_talking", stops_talking)
	items_container.connect("advance_menu", set_menu_level)

func starts_talking() -> void:
	on_dialogic = true

func stops_talking() -> void:
	on_dialogic = false

func toggle_menu() -> void:
	if quit_paused:
		return
	visible = not visible
	
	if visible:
		select_first_menu()
	else:
		party_container.visible = false
		items_container.visible = false
		quests_container.visible = false
		character_items_scroll.visible = false
		for item_button in items.get_children():
			item_button.focus_mode = Control.FOCUS_ALL
		use_item.focus_mode = Control.FOCUS_NONE
		toss_item.focus_mode = Control.FOCUS_NONE
		back_item.focus_mode = Control.FOCUS_NONE
		menu_level = 0
	
	get_tree().paused = not get_tree().paused

func _input(event:InputEvent) -> void:
	if quit_paused:
		return
	if event.is_action_pressed("pause") and not on_dialogic:
		toggle_menu()
	
	if event.is_action_pressed("ui_cancel"):
		match menu_level:
			0:
				toggle_menu()
			1:
				select_first_menu()
				close_second_menu()
			2:
				pass
			3:
				close_fourth_menu()

func set_menu_level(num:int) -> void:
	menu_level = num

func _on_party_pressed() -> void:
	menu_level = 1
	party_container.visible = true
	unselect_first_menu()
	favorite_container.get_child(0).selected_button.grab_focus()

func _on_items_pressed() -> void:
	menu_level = 1
	items_container.visible = true
	unselect_first_menu()
	if items_container.find_child("Items").get_child_count() > 0:
		items_container.find_child("Items").get_child(0).grab_focus()

func _on_quests_pressed() -> void:
	menu_level = 1
	quests_container.visible = true
	unselect_first_menu()
	if quests_container.get_child_count() > 0:
		quests_container.get_child(0).focus()

func select_first_menu() -> void:
	for button in button_container.get_children():
		button.focus_mode = Control.FOCUS_ALL
	button_container.get_child(0).grab_focus()

func unselect_first_menu() -> void:
	for button in button_container.get_children():
		button.focus_mode = Control.FOCUS_NONE

func close_second_menu() -> void:
	party_container.visible = false
	items_container.visible = false
	quests_container.visible = false

func close_fourth_menu() -> void:
	menu_level = 2
	character_items_scroll.visible = false
	if items_container.visible == true:
		use_item.focus_mode = Control.FOCUS_ALL
		toss_item.focus_mode = Control.FOCUS_ALL
		back_item.focus_mode = Control.FOCUS_ALL
		use_item.grab_focus()

func _on_quit_pressed() -> void:
	quit_paused = true
	get_tree().paused = not get_tree().paused
	unselect_first_menu()
	SignalBus.emit_signal("starts_talking")
	SignalBus.emit_signal("quit_game")
