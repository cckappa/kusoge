extends BattleManager

@export var black_rect : ColorRect
@onready var state_chart := %StateChart
@onready var lose_text := %LoseText
@onready var win_text := %WinText
@onready var loot_text := %LootText
@onready var audio_stream_player := %AudioStreamPlayer
@onready var continue_buttons := %ContinueButtons
@onready var continue_button := %ContinueButton
@onready var quit := %Quit
@onready var next := %Next
@onready var attack_menu := %AttackMenu

var attack_button:PackedScene = preload("res://scenes/attack_button.tscn")
var character_to_disable:Character
var interactive_stream:AudioStreamInteractive

var ability_status:={
	"ability":null,
	"item":null,
	"from":null,
	"target":null,
	"crit":null
}

var menu_level := 0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and menu_level == 0:
		attack_menu.visible = true
		attack_menu.get_child(0).grab_focus()
		menu_level = 2
		SignalBus.emit_signal("attack_menu_opened")
	if event.is_action_pressed("ui_cancel"):
		attack_menu.visible = false
		menu_level = 0
		SignalBus.emit_signal("attack_menu_closed", ability_status.from)

### 
### STATE ENTERS

func _on_enter_state_entered() -> void:
	interactive_stream = audio_stream_player.stream as AudioStreamInteractive
	connect_allies()
	connect_enemies()
	state_chart.send_event("setuped")

func _on_selecting_state_entered() -> void:
	for enemy_select in get_tree().get_nodes_in_group("selected_targets"):
		enemy_select.focus_mode = Control.FOCUS_NONE
	
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
	
	state_chart.send_event("repeat_select")

func _on_losing_state_entered() -> void:
	SignalBus.emit_signal("stop_crit")
	audio_stream_player.set("parameters/switch_to_clip", "LostBattle")
	lose_text.visible = true
	continue_buttons.visible = true
	continue_button.grab_focus()
	for enemy:Character in Globals.current_arrange_enemies.values():
		if enemy != null:
			enemy.current_container.untargeted()

func _on_winning_state_entered() -> void:
	SignalBus.emit_signal("stop_crit")
	audio_stream_player.set("parameters/switch_to_clip", "VictoryFanfare")
	var winning_allies:Array[Character] = alive_allies(Globals.current_arrange_allies)
	for ally in winning_allies:
		ally.current_container.disabled()
	
	for arrow in get_tree().get_nodes_in_group("selected_arrows"):
		arrow.focus_mode = Control.FOCUS_NONE
	var total_loots:Array[Array]
	for enemy:Character in Globals.current_arrange_enemies.values():
		if enemy != null:
			total_loots.append(enemy.add_loot_to_item_list())
			enemy.current_container.untargeted()
	
	win_text.visible = true
	for loot in total_loots:
		for item:Dictionary in loot:
			loot_text.text += str(item["display_name"]) + " x" + str(item["total"]) + "\n"
	loot_text.visible = true
	
	next.visible = true
	next.grab_focus()

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
	if from.current_container.check_timer():
		state_chart.send_event("target_select")

func change_to_target_selecting_item(item:Item, from:Character) -> void:
	ability_status.item = item
	ability_status.from = from
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
	print('from', ability_status.from.name)

func set_attack_menu() -> void:
	if attack_menu.get_child_count() > 0:
		for child in attack_menu.get_children():
			child.disconnect("pressed", _on_attack_button_pressed)
			child.queue_free()

	for attack:Ability in ability_status.from.abilities:
		var attack_button_instance := attack_button.instantiate()
		attack_button_instance.text = attack.ability_name
		attack_button_instance.connect("pressed", _on_attack_button_pressed.bind(ability_status.from, attack))
		attack_menu.add_child(attack_button_instance)

func _on_attack_button_pressed(from:Character, attack:Ability) -> void:
	SignalBus.emit_signal("ability_button_pressed", from, attack)
	attack_menu.visible = false
	menu_level = 0
	SignalBus.emit_signal("attack_menu_closed", ability_status.from)
	

func back_to_menu() -> void:
	state_chart.send_event("repeat_select")

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
		
