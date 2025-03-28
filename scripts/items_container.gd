extends HBoxContainer

signal advance_menu(num:int)

@onready var items := %Items
@onready var item_name := %ItemName
@onready var item_description := %ItemDescription
@onready var use_item := %UseItem
@onready var toss_item := %TossItem
@onready var back_item := %BackItem
@onready var character_items_container := %CharacterItemsContainer
@onready var character_items_scroll := %CharacterItemsScroll

var item_scene :PackedScene= preload("res://scenes/item_button.tscn")
var character_item_scene :PackedScene= preload("res://scenes/character_item.tscn")
var selected_item:Dictionary

func _ready() -> void:
	SignalBus.connect("item_added", update_item_list)
	SignalBus.connect("item_removed", update_item_list)
	create_item_list()
	create_character_item_list()

func create_item_list() -> void:
	for identifier : StringName in Items.item_list:
		var item_data : Dictionary = Items.item_list[identifier]
		var item_ui:= item_scene.instantiate()  # Get item dictionary
		item_ui.name = identifier
		item_ui.text = item_data.resource.display_name + " x" + str(int(item_data.total))
		item_ui.connect("focused", func() -> void:
			if Items.item_list.has(identifier):
				set_item_information(item_data.resource, int(Items.item_list[identifier].total))
			else:
				set_item_information(null, 0)
		)
		
		item_ui.connect("pressed", func() -> void:
			if Items.item_list.has(identifier):
				focus_action_buttons(item_data.resource, int(Items.item_list[identifier].total))
		)
		
		items.add_child(item_ui)  # Add to VBoxContainer


func update_item_list(_item:Item) -> void:
	var existing_items := {}  # Store references to existing items

	# Update existing UI items and track them
	for item_ui in items.get_children():
		var identifier := item_ui.name  # Each UI element's name is the identifier
		if Items.item_list.has(identifier):
			var item_data : Dictionary = Items.item_list[identifier]
			item_ui.text = item_data.resource.display_name + " x" + str(int(item_data.total))
			existing_items[identifier] = item_ui  # Mark as existing
		else:
			item_ui.queue_free()  # Remove if it no longer exists
			item_name.text = "Sin objeto."
			item_description.text = "Sin objeto."

	await get_tree().process_frame  # Ensure queued frees are processed

	# Add new items that don't have UI elements yet
	for identifier : StringName in Items.item_list:
		if not existing_items.has(identifier):  # If it's new, create it
			var item_data : Dictionary = Items.item_list[identifier]
			var item_ui := item_scene.instantiate()
			item_ui.name = identifier
			item_ui.text = item_data.resource.display_name + " x" + str(int(item_data.total))
			item_ui.connect("focused", set_item_information.bind(item_data.resource, item_data.total))
			item_ui.connect("pressed", focus_action_buttons.bind(item_data.resource, item_data.total))
			items.add_child(item_ui)  # Add to VBoxContainer


func reset_item_list() -> void:
	for item_button in items.get_children():
		item_button.queue_free()

func set_item_information(item:Item, total:int) -> void:
	if item != null:
		item_name.text = item.display_name + " x" + str(int(total))
		item_description.text = item.description
		if item.type == "KEY":
			use_item.text = "Key"
			toss_item.visible = false
		else:
			use_item.text = "Usar"
			toss_item.visible = true
	else:
		item_name.text = ""
		item_description.text = ""

func focus_action_buttons(item:Item, total:int) -> void:
	emit_signal("advance_menu", 2)
	selected_item = {"resource":item, "total":total}
	for item_button in items.get_children():
		item_button.focus_mode = Control.FOCUS_NONE
	
	back_item.focus_mode = Control.FOCUS_ALL
	if item.type == "KEY":
		use_item.text = "Key"
		use_item.focus_mode = Control.FOCUS_NONE
		toss_item.focus_mode = Control.FOCUS_NONE
		back_item.grab_focus()
	else:
		use_item.text = "Usar"
		use_item.focus_mode = Control.FOCUS_ALL
		toss_item.focus_mode = Control.FOCUS_ALL
		use_item.grab_focus()
	

func unfocus_action_buttons() -> void:
	var found_item :Button= null
	for item_button in items.get_children():
		item_button.focus_mode = Control.FOCUS_ALL
		if item_button.name == selected_item.resource.identifier:
			found_item = item_button
		print("Boton:", item_button.name)

	await get_tree().process_frame  # Ensure UI is ready
	
	print("Trying to find:", selected_item.resource.identifier)
	#var found_item := items.find_child(selected_item.resource.identifier)
	print("Found item:", found_item)

	if found_item: 
		await get_tree().process_frame
		if is_instance_valid(found_item) and found_item.is_inside_tree():
			found_item.grab_focus()
		else:
			if items.get_child_count() > 0:
				var first_child := items.get_child(0)
				if first_child:
					print("Focusing on first child:", first_child)
					first_child.focus_mode = Control.FOCUS_ALL
					first_child.grab_focus()
	else:
		var first_child := items.get_child(0)
		if first_child:
			print("Focusing on first child:", first_child)
			first_child.focus_mode = Control.FOCUS_ALL
			first_child.grab_focus()

	use_item.focus_mode = Control.FOCUS_NONE
	toss_item.focus_mode = Control.FOCUS_NONE
	back_item.focus_mode = Control.FOCUS_NONE
	selected_item = {"resource" : null, "total" : null}
	emit_signal("advance_menu", 1)

func create_character_item_list() -> void:
	for character in Globals.current_characters:
		var character_item := character_item_scene.instantiate()
		character_item.character = character
		character_item.connect("pressed_character_item", use_item_on_character)
		character_items_container.add_child(character_item)
	for character in Globals.party:
		var character_item := character_item_scene.instantiate()
		character_item.character = character
		character_item.connect("pressed_character_item", use_item_on_character)
		character_items_container.add_child(character_item)

func update_character_item_list() -> void:
	for character_item in character_items_container.get_children():
		if character_item.character != null:
			character_item.set_info()
		else:
			pass

func unfocus_character_item_list() -> void:
	for character_item in character_items_container.get_children():
		character_item.unfocus()

func focus_character_item_list() -> void:
	for character_item in character_items_container.get_children():
		character_item.set_focus()

func _on_use_item_pressed() -> void:
	emit_signal("advance_menu", 3)
	character_items_scroll.visible = true
	focus_character_item_list()
	character_items_container.get_child(0).focus()
	use_item.focus_mode = Control.FOCUS_NONE
	toss_item.focus_mode = Control.FOCUS_NONE
	back_item.focus_mode = Control.FOCUS_NONE
	#reset_item_list()
	#create_item_list()

func use_item_on_character(characters:Array[Character]) -> void:
	selected_item.resource.use_item(characters)
	# update_item_list()
	update_character_item_list()
	unfocus_character_item_list()
	character_items_scroll.visible = false
	unfocus_action_buttons()

func get_current_total() -> int:
	var item_resource :Dictionary= Items.item_list[selected_item.resource.identifier]
	if item_resource != null:
		return item_resource.total
	else:
		return 0
	

func _on_toss_item_pressed() -> void:
	pass # Replace with function body.


func _on_back_item_pressed() -> void:
	unfocus_action_buttons()
