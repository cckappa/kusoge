extends LimboState

@onready var info_items_v_box:=%InfoItemsVBox
@onready var item_descriptions_control:=%ItemDescriptionsControl
@onready var sprite_item:=%SpriteItem

const INFO_ITEM_TEXT_PATH:="res://scenes/menu/info_item_text.tscn"

func _setup() -> void:
	SignalBus.connect("item_added",_on_item_changed)
	SignalBus.connect("item_removed",_on_item_changed)
	SignalBus.connect("menu_item_focus_entered", _item_focused)
	_free_children()
	add_items()
	
func _enter() -> void:
	blackboard.get_var("items_control").visible = true
	if Items.item_list.size() > 0:
		blackboard.get_var("item_descriptions_control").visible = true
	blackboard.get_var("pov_container").move_items()
	info_items_v_box.get_child(0).grab_focus()

func _input(event:InputEvent) -> void:
	if event.is_action_pressed("back") and is_active():
		dispatch("to_item_hidden_state", "back")
	elif event.is_action_pressed("pause") and is_active():
		dispatch("to_item_hidden_state", "pause")


func _free_children() -> void:
	if Items.item_list.size() > 0:
		for item in info_items_v_box.get_children():
			item.queue_free()


func add_items() -> void:
	const info_item_text = preload(INFO_ITEM_TEXT_PATH)

	for item:StringName in Items.item_list:
		var item_data:Dictionary=Items.item_list[item]
		var info_item_text_instance := info_item_text.instantiate()
		info_items_v_box.add_child(info_item_text_instance)
		info_item_text_instance.setup_info(item_data, int(item_data.total))
	
func _on_item_changed(_item:Item)-> void:
	_free_children()
	add_items()

func _item_focused(_item:Item) -> void:
	sprite_item.texture = _item.icon
