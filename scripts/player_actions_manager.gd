extends BattleManager

@export var black_rect : ColorRect
@export var arc_radius: float = 150.0
@export var max_arc_angle: float = 120.0
@export var min_item_spacing: float = 50.0
@export var x_offset_multiplier: float = 12.0
@export var y_offset_multiplier: float = 0.6
@export var animation_stagger: float = 0.7  # Delay between each item's animation start

@onready var state_chart := %StateChart
@onready var lose_text := %LoseText
@onready var win_text := %WinText
@onready var loot_text := %LootText
@onready var audio_stream_player := %AudioStreamPlayer
@onready var continue_buttons := %ContinueButtons
@onready var continue_button := %ContinueButton
@onready var quit := %Quit
@onready var attack_menu := %AttackMenu
@onready var item_menu := %ItemMenu
@onready var victory_kio := %VictoryKio
@onready var loot_container := %LootContainer

var attack_button:PackedScene = preload("res://scenes/attack_button.tscn")
var item_battle_button:PackedScene = preload("res://scenes/item_battle_button.tscn")
var loot_item:PackedScene = preload("res://scenes/loot_item.tscn")

var character_to_disable:Character
var interactive_stream:AudioStreamInteractive

var ability_status:={
	"ability":null,
	"item":null,
	"from":null,
	"target":null,
	"crit":null
}

var menu_level := "base"

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and menu_level == "base":
		attack_menu.visible = true
		menu_level = "attack"
		SignalBus.emit_signal("attack_menu_opened")
		await get_tree().create_timer(0.1).timeout
		attack_menu.get_child(0).grab_focus()
	
	if event.is_action_pressed("ui_accept") and menu_level == "victory":
		victory_kio.play_hide_animation()

	if event.is_action_pressed("ui_accept") and menu_level == "loots":
		SignalBus.emit_signal("loot_collected")

	if event.is_action_pressed("use_item") and menu_level == "base":
		set_item_menu()
		item_menu.visible = true
		menu_level = "item"
		SignalBus.emit_signal("item_menu_opened")
		await get_tree().create_timer(0.1).timeout
		if item_menu.get_child_count() > 0:
			item_menu.get_child(0).grab_focus()

	if event.is_action_pressed("run_away") and menu_level == "base":
		SignalBus.emit_signal("run_away")

	if event.is_action_pressed("ui_cancel") and (menu_level != "victory" or menu_level == "loots"):
		attack_menu.visible = false
		item_menu.visible = false
		SignalBus.emit_signal("menu_closed", ability_status.from)
		menu_level = "base"
		SignalBus.emit_signal("stop_crit")
		set_attack_menu()
		state_chart.send_event("repeat_select")
	

### 
### STATE ENTERS

func _on_enter_state_entered() -> void:
	interactive_stream = audio_stream_player.stream as AudioStreamInteractive
	connect_allies()
	connect_enemies()
	victory_kio.connect("victory_finished_hiding", to_looting)
	state_chart.send_event("setuped")

func _on_selecting_state_entered() -> void:
	for enemy_select in get_tree().get_nodes_in_group("selected_targets"):
		enemy_select.focus_mode = Control.FOCUS_NONE

	menu_level = "base"

	SignalBus.emit_signal("menu_closed", ability_status.from)
	SignalBus.emit_signal("stop_crit")
	
	var allies:Array[Character] = alive_allies(Globals.current_arrange_allies)
	if allies.size() > 0:
		if ability_status.from != null:
			if ability_status.from.current_container.submenu_level == 2:
				pass
			else:
				if ability_status.from.current_hp > 0:
					ability_status.from.current_container.selected()
				else:
					allies[0].current_container.selected()
					ability_status.from = allies[0]
		else:
			allies[0].current_container.selected()



func _on_target_selecting_state_entered() -> void:
	print("Target selecting state entered")
	for enemy_select in get_tree().get_nodes_in_group("selected_targets"):
		if enemy_select.visible == true:
			enemy_select.focus_mode = Control.FOCUS_ALL
	
	var enemies:Array[Character] = alive_enemies(Globals.current_arrange_enemies)
	var allies:Array[Character] = alive_allies(Globals.current_arrange_allies)
	if ability_status.ability != null and ability_status.ability.effect == "POSITIVE":
		if allies.size() > 0:
			if ability_status.from != null and ability_status.from.current_hp > 0:
				ability_status.from.current_container.target_selected()
			else:
				allies[0].current_container.target_selected()
	elif ability_status.ability != null and ability_status.ability.effect == "NEGATIVE":
		if enemies.size() > 0:
				enemies[0].current_container.selected()
	SignalBus.emit_signal("action_selected", "ABILITY")

func _on_target_selecting_item_state_entered() -> void:
	print("Target selecting item state entered")
	for enemy_select in get_tree().get_nodes_in_group("selected_targets"):
		if enemy_select.visible == true:
			enemy_select.focus_mode = Control.FOCUS_ALL
	
	var enemies:Array[Character] = alive_enemies(Globals.current_arrange_enemies)
	var allies:Array[Character] = alive_allies(Globals.current_arrange_allies)
	if ability_status.item != null and (ability_status.item.type == "HEAL" or ability_status.item.type == "BUFF"):
		if allies.size() > 0:
			if ability_status.from != null and ability_status.from.current_hp > 0:
				ability_status.from.current_container.target_selected()
			else:
				allies[0].current_container.target_selected()
	elif ability_status.item != null and (ability_status.item.type == "DAMAGE" or ability_status.item.type == "DEBUFF"):
		if enemies.size() > 0:
				enemies[0].current_container.selected()
	SignalBus.emit_signal("action_selected", "ITEM")

func _on_iteming_state_entered() -> void:
	use_item(ability_status.item, ability_status.target)
	SignalBus.emit_signal("item_removed", ability_status.item)
	ability_status.from.current_container.unselected()
	state_chart.send_event("repeat_select")

func _on_abilitying_state_entered() -> void:
	use_ability(ability_status.ability, ability_status.from, ability_status.target, ability_status.crit)
	ability_status.from.current_container.unselected()
	state_chart.send_event("repeat_select")

func _on_inhabilitating_state_entered() -> void:
	character_to_disable.current_container.death()
	if ability_status.from != null and character_to_disable.name == ability_status.from.name:
		character_to_disable.current_container.disabled()
	
	state_chart.set_expression_property("alive_enemies", alive_enemies(Globals.current_arrange_enemies).size())
	state_chart.send_event("wins")
	state_chart.set_expression_property("alive_allies", alive_allies(Globals.current_arrange_allies).size())
	state_chart.send_event("lost")

	if menu_level == "selecting":
		attack_menu.visible = false
		item_menu.visible = false
		SignalBus.emit_signal("menu_closed", ability_status.from)
		menu_level = "base"
		SignalBus.emit_signal("stop_crit")
		set_attack_menu()
		state_chart.send_event("repeat_select")
	
	if menu_level == "attack" :
		print("Menu level attack")
	
	if menu_level == "item":
		print("Menu item")
	
	if menu_level == "base":
		attack_menu.visible = false
		item_menu.visible = false
		SignalBus.emit_signal("menu_closed", ability_status.from)
		menu_level = "base"
		SignalBus.emit_signal("stop_crit")
		set_attack_menu()
		state_chart.send_event("repeat_select")
	

func _on_losing_state_entered() -> void:
	SignalBus.emit_signal("stop_crit")
	menu_level = "lost"
	attack_menu.visible = false
	item_menu.visible = false
	SignalBus.emit_signal("menu_closed", ability_status.from)
	audio_stream_player.set("parameters/switch_to_clip", "LostBattle")
	lose_text.visible = true
	continue_buttons.visible = true
	continue_button.grab_focus()
	for enemy:Character in Globals.current_arrange_enemies.values():
		if enemy != null:
			enemy.current_container.untargeted()

func _on_winning_state_entered() -> void:
	SignalBus.emit_signal("stop_crit")
	menu_level = "victory"
	attack_menu.visible = false
	item_menu.visible = false
	SignalBus.emit_signal("menu_closed", ability_status.from)
	Globals.apply_win_stakes()
	audio_stream_player.set("parameters/switch_to_clip", "VictoryFanfare")
	var winning_allies:Array[Character] = alive_allies(Globals.current_arrange_allies)
	for ally in winning_allies:
		ally.current_container.disabled()
	
	for arrow in get_tree().get_nodes_in_group("selected_arrows"):
		arrow.focus_mode = Control.FOCUS_NONE

	for enemy:Character in Globals.current_arrange_enemies.values():
		if enemy != null:
			enemy.current_container.untargeted()
	
	victory_kio.play_victory_animation()


func _on_looting_state_entered() -> void:
	print("Looting state entered")
	menu_level = "loots"
	var total_loots:Array[Array]
	for enemy:Character in Globals.current_arrange_enemies.values():
		if enemy != null:
			total_loots.append(enemy.add_loot_to_item_list())

	var loot_items:Array[Dictionary]
	for loot in total_loots:
		for item:Dictionary in loot:
			loot_items.append(item)

	loot_container.visible = true
	spawn_loot(loot_items)
	
	# next.visible = true
	# next.grab_focus()

###
### STATE INPUTS

###
### STATE PROCESSESS

###
### FUNCTIONS

func connect_allies() -> void:
	for ally:Character in Globals.current_arrange_allies.values():
		if ally != null:
			ally.current_container.connect("disable_character", disable_character)
			ally.current_container.connect("character_selected", character_status_select)
			ally.current_container.connect("ability_selected", change_to_target_selecting)
			ally.current_container.connect("item_selected", change_to_target_selecting_item)
			ally.current_container.connect("uses_item", change_to_iteming)
			ally.current_container.connect("uses_ability", change_to_abilitying)
			ally.current_container.connect("back_to_menu", back_to_menu)

func connect_enemies()->void:
	for enemy:Character in Globals.current_arrange_enemies.values():
		if enemy != null:
			enemy.current_container.connect("uses_ability", change_to_abilitying)
			enemy.current_container.connect("disable_character", disable_character)

func change_to_target_selecting(ability:Ability, from:Character) -> void:
	ability_status.ability = ability
	ability_status.from = from
	print('from to target selecting', ability_status.from.name)
	if from.current_container.check_timer():
		print('can select target')
		state_chart.send_event("target_select")
		attack_menu.visible = false
		menu_level = "selecting"

func change_to_target_selecting_item(from:Character, item:Item) -> void:
	ability_status.item = item
	ability_status.from = from
	item_menu.visible = false
	menu_level = "selecting"
	state_chart.send_event("target_select_item")

func change_to_abilitying(target:Character, crit:bool=false) -> void:
	ability_status.target = target
	ability_status.crit = crit
	state_chart.send_event("using_ability")

func change_to_iteming(target:Character) -> void:
	ability_status.target = target
	state_chart.send_event("using_item")

func use_ability(ability:Ability, from:Character, target:Character, crit:bool=false) -> void:
	if from.current_container.reset_timer(ability.wait_time):
		if from.current_hp <= 0:
			SignalBus.emit_signal("stop_crit")
		else:
			play_attack_animation(ability, target.current_container.find_child("ParticleCenter"), target, crit)

func landed_ability(ability:Ability, target:Character, crit:bool=false) -> void:
	print("Landed ability: ", ability.ability_name, " on target: ", target.name, " with crit: ", crit)
	ability.use_ability(target, crit)

func use_item(item:Item, target:Character) -> void:
	item.use_item([target])
	ability_status.item = null

func disable_character(character:Character) -> void:
	character_to_disable = character
	state_chart.send_event("inhabilitated")

func character_status_select(character:Character) -> void:
	ability_status.from = character
	set_attack_menu()
	set_item_menu()
	print('from', ability_status.from.name)

func set_attack_menu() -> void:
	if attack_menu.get_child_count() > 0:
		for child in attack_menu.get_children():
			if child.has_connections("pressed"):
				child.disconnect("pressed", _on_attack_button_pressed)
			child.queue_free()

	for attack:Ability in ability_status.from.abilities:
		var attack_button_instance := attack_button.instantiate()
		attack_button_instance.text = attack.ability_name
		attack_button_instance.connect("pressed", _on_attack_button_pressed.bind(ability_status.from, attack))
		attack_menu.add_child(attack_button_instance)

func set_item_menu() -> void:
	if item_menu.get_child_count() > 0:
		for child in item_menu.get_children():
			if child.has_connections("pressed"):
				child.disconnect("pressed", _on_item_button_pressed)
			child.queue_free()

	for identifier:StringName in Items.item_list:
		var item_button_instance := item_battle_button.instantiate()
		item_button_instance.text = "%s x%s" % [Items.item_list[identifier].resource.display_name, int(Items.item_list[identifier].total)]
		item_button_instance.connect("pressed", _on_item_button_pressed.bind(ability_status.from, Items.item_list[identifier].resource))
		item_menu.add_child(item_button_instance)
	
	if item_menu.get_child_count() == 0:
		var no_items_label := Button.new()
		no_items_label.text = "No items"
		item_menu.add_child(no_items_label)

func _on_attack_button_pressed(from:Character, attack:Ability) -> void:
	SignalBus.emit_signal("ability_button_pressed", from, attack)

func _on_item_button_pressed(from:Character, item:Item) -> void:
	SignalBus.emit_signal("item_button_pressed", from, item)

func back_to_menu() -> void:
	state_chart.send_event("repeat_select")

func to_looting() -> void:
	state_chart.send_event("loots")
	
	
func alive_allies(current_arrange_allies:Dictionary) -> Array[Character]:
	var alive_allies_arr : Array[Character]
	for ally : Character in current_arrange_allies.values():
		if ally != null and ally.current_hp > 0:
			alive_allies_arr.append(ally)
	
	return alive_allies_arr

func alive_enemies(current_arrange_enemies:Dictionary) -> Array[Character]:
	var alive_enemies_arr : Array[Character]
	for enemy : Character in current_arrange_enemies.values():
		if enemy != null and enemy.current_hp > 0:
			alive_enemies_arr.append(enemy)
	
	return alive_enemies_arr


func play_attack_animation(ability: Ability, parent_node: Node, target:Character, crit:bool=false) -> void:
	if ability.attack_animation:
		var animation_instance := ability.attack_animation.instantiate()
		animation_instance.connect("landed_ability", landed_ability.bind(ability, target, crit))
		parent_node.add_child(animation_instance)
		
func spawn_loot(loot_data: Array) -> void:
	"""
	Spawns loot items with animation
	loot_data: Array of dictionaries containing loot information
	Example: [{"name": "Sword", "icon": preload("res://sword.png")}, {...}]
	"""
	var loot_count := loot_data.size()
	if loot_count == 0:
		return
	
	# Calculate positions for items
	var positions := _calculate_arc_positions(loot_count)
	print("Calculated positions: ", positions)
	
	# Spawn each loot item
	for i in range(loot_count):
		var loot_item_instance := loot_item.instantiate()
		if loot_item_instance:
			loot_container.add_child(loot_item_instance)
			loot_item_instance.item_name = loot_data[i].resource.display_name
			loot_item_instance.item_quantity = loot_data[i].total
			loot_item_instance.animate_loot_spawn(positions[i], i * animation_stagger)  # Stagger animations
		# loot_item_instance.icon = loot_data[i].resource.icon

func _calculate_arc_positions(count: int) -> Array[Vector2]:
	"""Calculates positions for items in an arc formation"""
	var positions: Array[Vector2] = []
	
	var center := (get_viewport().get_visible_rect().size / 2) - Vector2(1470.0/2, 504.0/2) #MAGIC NUMBER oops LOOT ITEM PANEL SIZE / 2
	
	if count == 1:
		# Single item goes in center
		positions.append(center)
	else:
		# Calculate the required angle based on item spacing
		var chord_length := min_item_spacing
		var required_angle := 2.0 * asin(chord_length / (2.0 * arc_radius))
		var total_angle: float = min(deg_to_rad(max_arc_angle), required_angle * (count - 1))
		
		# Distribute items evenly across the calculated angle
		var angle_step := total_angle / (count - 1) if count > 1 else 0.0
		var start_angle := -total_angle / 2.0
		
		for i in range(count):
			var angle := start_angle + (angle_step * i)
			# Use negative sin for Y to make the arc curve upward (items above center)
			var offset := Vector2(
				sin(angle) * arc_radius * x_offset_multiplier,  # X offset
				-abs(cos(angle)) * arc_radius * y_offset_multiplier  # Y offset (upward arc)
			)
			positions.append(center + offset)
	
	return positions
