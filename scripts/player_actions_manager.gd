extends BattleManager

@export var black_rect : ColorRect
@export var arc_radius: float = 150.0
@export var max_arc_angle: float = 120.0
@export var min_item_spacing: float = 50.0
@export var x_offset_multiplier: float = 12.0
@export var y_offset_multiplier: float = 0.6
@export var animation_stagger: float = 0.7  # Delay between each item's animation start

@onready var state_chart := %StateChart
@onready var win_text := %WinText
@onready var loot_text := %LootText
@onready var audio_stream_player := %AudioStreamPlayer
@onready var lose_animation_player := %LoseAnimationPlayer
@onready var continue_buttons := %ContinueButtons
@onready var continue_button := %ContinueButton
@onready var quit := %Quit
@onready var attack_menu := %AttackMenu
@onready var ally_thumbnail_container := %AllyThumbnailContainer
@onready var ability_name_container := %AbilityNameContainer
@onready var ally_thumbnail := %AllyThumbnail
@onready var damage_value := %DamageValue
@onready var icon_dagger := %IconDagger
@onready var icon_health := %IconHealth
@onready var time_value := %TimeValue
@onready var item_menu := %ItemMenu
@onready var item_name_container := %ItemNameContainer
@onready var no_items_label := %NoItemsLabel
@onready var item_thumbnail := %ItemThumbnail
@onready var item_value := %ItemValue
@onready var item_icon_dagger := %ItemIconDagger
@onready var item_icon_health := %ItemIconHealth
@onready var victory_kio := %VictoryKio
@onready var loot_container := %LootContainer
@onready var cooldown_not_finished_sound := %CooldownNotFinishedSound
@onready var ally_portraits := %AllyPortraits

var attack_button:PackedScene = preload("res://scenes/attack_button.tscn")
var ability_name:PackedScene = preload("res://scenes/ability_name.tscn")
var item_name:PackedScene = preload("res://scenes/item_name.tscn")
var item_battle_button:PackedScene = preload("res://scenes/item_battle_button.tscn")
var loot_item:PackedScene = preload("res://scenes/loot_item.tscn")

var character_to_disable:Character
var interactive_stream:AudioStreamInteractive
var talking:bool=false

var ability_status:={
	"ability":null,
	"item":null,
	"from":null,
	"target":null,
	"crit":null
}

var menu_level := "base"

func _input(event: InputEvent) -> void:
	if talking:
		return

	if event.is_action_pressed("ui_accept") and menu_level == "base":
		attack_menu.visible = true
		menu_level = "attack"
		SignalBus.emit_signal("attack_menu_opened")
		ability_status.from.current_container.check_timer()
		ability_name_container.get_child(0).ability_button.grab_focus()
		Functions.set_game_speed(0.1)
		get_viewport().set_input_as_handled()

	if event.is_action_pressed("ui_accept") and menu_level == "victory":
		victory_kio.play_hide_animation()

	if event.is_action_pressed("ui_accept") and menu_level == "loots":
		SignalBus.emit_signal("loot_collected")

	if event.is_action_pressed("use_item") and menu_level == "base":
		set_item_menu()
		item_menu.visible = true
		menu_level = "item"
		SignalBus.emit_signal("item_menu_opened")
		if item_name_container.get_child_count() > 0:
			await get_tree().process_frame
			item_name_container.get_child(0).item_button.grab_focus()
		else:
			pass
		Functions.set_game_speed(0.1)
		get_viewport().set_input_as_handled()

	if event.is_action_pressed("run_away") and menu_level == "base":
		Functions.set_game_speed(1.0)
		SignalBus.emit_signal("run_away")

	if event.is_action_pressed("ui_cancel") and menu_level != "victory" and menu_level != "loots" and menu_level != "lost":
		Functions.set_game_speed(1.0)
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
	Functions.set_dialogic_auto_advance(true)
	SignalBus.connect("starts_talking", _on_starts_talking)
	SignalBus.connect("stops_talking", _on_stops_talking)
	SignalBus.connect("enemy_victory_dialogs_ended", _on_enemy_victory_dialogs_ended)
	interactive_stream = audio_stream_player.stream as AudioStreamInteractive
	connect_allies()
	connect_enemies()
	SignalBus.connect("ability_name_focus_entered", set_ability_info)
	SignalBus.connect("item_name_focus_entered", set_item_info)
	SignalBus.connect("ability_cooldown_not_finished", cooldown_not_finished)
	victory_kio.connect("victory_finished_hiding", to_looting)
	state_chart.send_event("setuped")

func _on_selecting_state_entered() -> void:
	Functions.set_game_speed(1.0)
	for enemy_select in get_tree().get_nodes_in_group("selected_targets"):
		enemy_select.focus_mode = Control.FOCUS_NONE

	menu_level = "base"

	SignalBus.emit_signal("menu_closed", ability_status.from)
	SignalBus.emit_signal("stop_crit")
	
	var allies:Array[Character] = alive_allies(Globals.current_arrange_allies)
	if allies.size() > 0:
		for ally in allies:
			ally.current_container.hide_fake_arrow()

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
	
	var enemies:Array[Character] = alive_enemies(Globals.current_arrange_enemies)
	var allies:Array[Character] = alive_allies(Globals.current_arrange_allies)
	if ability_status.ability != null and ability_status.ability.effect == "POSITIVE":
		if allies.size() > 0:
			for ally in allies:
				ally.current_container.target_focus()
			if ability_status.from != null and ability_status.from.current_hp > 0:
				ability_status.from.current_container.target_selected()
			else:
				allies[0].current_container.target_selected()
	elif ability_status.ability != null and ability_status.ability.effect == "NEGATIVE":
		if enemies.size() > 0:
			for enemy in enemies:
				enemy.current_container.target_focus()

			enemies[0].current_container.selected()
	SignalBus.emit_signal("action_selected", "ABILITY")

func _on_target_selecting_item_state_entered() -> void:
	print("Target selecting item state entered")
	
	var enemies:Array[Character] = alive_enemies(Globals.current_arrange_enemies)
	var allies:Array[Character] = alive_allies(Globals.current_arrange_allies)
	if ability_status.item != null and (ability_status.item.type == "HEAL" or ability_status.item.type == "BUFF"):
		if allies.size() > 0:
			for ally in allies:
				ally.current_container.target_focus()

			if ability_status.from != null and ability_status.from.current_hp > 0:
				ability_status.from.current_container.target_selected()
			else:
				allies[0].current_container.target_selected()
	elif ability_status.item != null and (ability_status.item.type == "DAMAGE" or ability_status.item.type == "DEBUFF"):
		if enemies.size() > 0:
			for enemy in enemies:
				enemy.current_container.target_focus()

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
	var is_enemy:bool = character_to_disable.get("dialog") != null

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
	
	if menu_level == "base" || !is_enemy:
		attack_menu.visible = false
		item_menu.visible = false
		SignalBus.emit_signal("menu_closed", ability_status.from)
		menu_level = "base"
		SignalBus.emit_signal("stop_crit")
		set_attack_menu()
		state_chart.send_event("repeat_select")
	

func _on_losing_state_entered() -> void:
	Functions.set_game_speed(1.0)
	SignalBus.emit_signal("stop_crit")
	menu_level = "lost"
	attack_menu.visible = false
	item_menu.visible = false
	# SignalBus.emit_signal("menu_closed", ability_status.from)
	SignalBus.emit_signal("enemy_victory_dialogs_started")
	

func _on_winning_state_entered() -> void:
	Functions.set_game_speed(1.0)
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
	ally_thumbnail.texture = ability_status.from.character_portrait
	if ability_name_container.get_child_count() > 0:
		for child in ability_name_container.get_children():
			if child.ability_button.has_connections("pressed"):
				child.ability_button.disconnect("pressed", _on_attack_button_pressed)
			child.queue_free()

	for attack:Ability in ability_status.from.abilities:
		var ability_name_instance := ability_name.instantiate()
		ability_name_container.add_child(ability_name_instance)
		ability_name_instance.set_ability_info(attack)
		ability_name_instance.ability_button.connect("pressed", _on_attack_button_pressed.bind(ability_status.from, attack))

func set_item_menu() -> void:
	if item_name_container.get_child_count() > 0:
		for child in item_name_container.get_children():
			if child.item_button.has_connections("pressed"):
				child.item_button.disconnect("pressed", _on_item_button_pressed)
			child.queue_free()

	for identifier:StringName in Items.item_list:
		if Items.item_list[identifier].resource.type != "KEY":
			var item_name_instance := item_name.instantiate()
			item_name_container.add_child(item_name_instance)
			item_name_instance.set_item_info(Items.item_list[identifier].resource, int(Items.item_list[identifier].total))
			item_name_instance.item_button.connect("pressed", _on_item_button_pressed.bind(ability_status.from, Items.item_list[identifier].resource))

	if item_name_container.get_child_count() == 0:
		no_items_label.visible = true
	else:
		no_items_label.visible = false

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
			loot_item_instance.item_icon = loot_data[i].resource.icon
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

func set_ability_info(ability:Ability) -> void:
	if ability.effect == "POSITIVE":
		damage_value.text = str(ability.heal_points)
		icon_health.visible = true
		icon_dagger.visible = false
	elif ability.effect == "NEGATIVE":
		damage_value.text = str(ability.damage_points)
		icon_health.visible = false
		icon_dagger.visible = true
	else:
		damage_value.text = "0"
	
	time_value.text = str(ability.wait_time)

func set_item_info(item:Item) -> void:
	if item.type == "HEAL":
		item_value.text = str(item.item_effect.heal_amount)
		item_icon_health.visible = true
		item_icon_dagger.visible = false
	# elif item.type == "DAMAGE":
	# 	item_value.text = str(item.damage_points)
	# 	item_icon_health.visible = false
	# 	item_icon_dagger.visible = true
	else:
		item_value.text = "0"
	
	item_thumbnail.texture = item.icon

func cooldown_not_finished() -> void:
	print("Ability cooldown not finished")
	cooldown_not_finished_sound.play()
	var tween := create_tween()
	tween.tween_property(ally_thumbnail_container, "modulate", Color.hex(0xff5c47ff), 0.01)
	tween.tween_property(ally_thumbnail_container, "modulate", Color.hex(0xffffffff), 0.01)
	tween.tween_property(ally_thumbnail_container, "modulate", Color.hex(0xff5c47ff), 0.02)
	tween.tween_property(ally_thumbnail_container, "modulate", Color.hex(0xffffffff), 0.02)

func _on_starts_talking() -> void:
	Functions.set_game_speed(1.0)
	talking = true
	for ability in get_tree().get_nodes_in_group("ability_animations"):
		ability.animation_player.pause()
	if ability_status.from != null:
		ability_status.from.current_container.menu.visible = false
	else:
		ally_portraits.get_child(0).menu.visible = false



func _on_stops_talking() -> void:
	talking = false
	for ability in get_tree().get_nodes_in_group("ability_animations"):
		ability.animation_player.play()
	if ability_status.from.current_container != null:
		ability_status.from.current_container.selected()
	else:
		ally_portraits.get_child(0).selected()

func _on_enemy_victory_dialogs_ended() -> void:
	audio_stream_player.set("parameters/switch_to_clip", "LostBattle")
	lose_animation_player.play("lose_screen")
	# lose_text.visible = true
	continue_buttons.visible = true
	continue_button.grab_focus()
	for enemy:Character in Globals.current_arrange_enemies.values():
		if enemy != null:
			enemy.current_container.untargeted()