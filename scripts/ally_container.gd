class_name AllyContainer
extends CharacterContainer

signal character_selected(character: Character)
signal ability_selected(ability:Ability, from:Character)
signal uses_ability(target:Character)
signal disable_character(character:Character)
signal back_to_menu()
signal item_selected(item:Item, from:Character)
signal uses_item(target:Character)

@onready var progress_bar := %TextureProgressBar
@onready var timer := $Timer
@onready var texture_rect := %TextureRect
@onready var life_bar := %LifeBar
@onready var health_points := %HealthPoints
@onready var selected_arrow := %SelectedArrow
@onready var ability_arrow := %AbilityArrow
@onready var death_texture := %DeathTexture
@onready var menu := %Menu
@onready var target_button := %TargetButton
@onready var bus_index := AudioServer.get_bus_index("Music")
@onready var damage_value := %DamageValue
@onready var animation_player := %AnimationPlayer
@onready var heal_particles_long := %HealParticlesLong
@onready var heal_particles_star := %HealParticlesStar
@onready var crit_particles_long_circle := %CritParticlesLongCircle
@onready var circle_thick := %CircleThick
@onready var circle_thin := %CircleThin
@onready var burning_sound := %BurningSound
@onready var strong_hit_sound := %StrongHitSound

@onready var hit_sound := %HitSound
@onready var heal_sound := %HealSound
@onready var crit_sound := %CritSound


const TARGET_HEAL = preload("res://assets/icons/target_heal.svg")
const TARGET_SELECT = preload("res://assets/icons/target_select.svg")
const menu_theme = preload("res://assets/themes/menu_theme.tres")
const block_ability = preload("res://assets/resources/abilities/basic_armour.tres") 

var front_texture : Texture
var character_portrait :  Texture
var character : Character
var max_hp := 0
var current_hp := 0
var attack_list : Array[Ability]
var submenu_level := 0
var game_slow_speed := 0.2
var pitch_effect:AudioEffectPitchShift
var reverb_effect:AudioEffectReverb
var crits := false
var current_action:String = ""
var current_attack_menu:VBoxContainer


func _ready() -> void:
	# SignalBus.connect("item_removed", _on_item_removed)
	SignalBus.connect("action_selected", set_current_action)
	texture_rect.texture = character_portrait
	damage_value.visible = false
	ability_arrow.select_arrow(arrange_position, "ally")
	pitch_effect = AudioServer.get_bus_effect(bus_index, 0) as AudioEffectPitchShift
	reverb_effect = AudioServer.get_bus_effect(bus_index, 1) as AudioEffectReverb
	SignalBus.connect("crits_signal", crit_enabled)
	SignalBus.connect("stop_crit", crit_disabled)
	SignalBus.connect("attack_menu_opened", unfocus_arrows)
	SignalBus.connect("item_menu_opened", unfocus_arrows)
	SignalBus.connect("menu_closed", focus_current_character)
	SignalBus.connect("ability_button_pressed", ability_pressed)
	SignalBus.connect("item_button_pressed", item_button_pressed)


	# for identifier:StringName in Items.item_list:
	# 	var item_button := Button.new()
	# 	item_button.text = "%s x%s" % [Items.item_list[identifier].resource.display_name, int(Items.item_list[identifier].total)]
	# 	item_button.theme = menu_theme
	# 	item_menu.add_child(item_button)
	# 	item_button.add_to_group("submenu_item")
	# 	item_button.connect("pressed", _on_item_button_pressed.bind(Items.item_list[identifier].resource))

func _process(delta:float) -> void:
	if timer.time_left != 0: 
		var value_timer :int = ceil(((timer.wait_time - timer.time_left) / timer.wait_time) * 100)
		progress_bar.value = value_timer
		progress_bar.modulate = Color(1,1,1,1)
	else:
		progress_bar.modulate = Color(0, 1.657, 3.15, 1)


func set_max_life(hp: int) -> void:
	life_bar.max_value = max_hp
	life_bar.value = hp
	health_points.text = "%s/%s" % [hp, max_hp]
	if hp <= 0:
		death()

func set_health(hp:int, effect:StringName, _crit:bool=false) -> void:
	if effect == "DAMAGE":
		damage_animation(_crit)
	elif effect == "HEAL":
		heal_animation(_crit)
	damage_value.text = "[center]%s" % str(int(current_hp - hp))
	var tween := get_tree().create_tween()
	tween.tween_property(life_bar, "value", hp, 0.5)
	var tween2 := get_tree().create_tween()
	tween2.tween_property(health_points, "text", "%s/%s" % [hp, max_hp], 0.5)
	current_hp = hp
	SignalBus.emit_signal("stop_crit")
	await tween.finished
	print(current_hp, '-', character.name)
	if current_hp <= 0:
		emit_signal("disable_character", character)

func selected() -> void:
	selected_arrow.grab_focus()

func target_selected() -> void:
	target_button.grab_focus()

func focus_current_character(from:Character) -> void:
	focus_arrows()
	submenu_level = 0
	if from == null:
		# menu.visible = true
		return
	if from.current_container == self:
		selected_arrow.grab_focus()
		menu.visible = true
	

func unselected() ->void:
	submenu_level = 0
	selected_arrow.button_pressed = false
	for arrow in get_tree().get_nodes_in_group("selected_arrows"):
		arrow.focus_mode = Control.FOCUS_ALL
	selected_arrow.grab_focus()

func unfocus_arrows() -> void:
	for arrow in get_tree().get_nodes_in_group("selected_arrows"):
		arrow.focus_mode = Control.FOCUS_NONE

func focus_arrows() -> void:
	for arrow in get_tree().get_nodes_in_group("selected_arrows"):
		arrow.focus_mode = Control.FOCUS_ALL

func death() -> void:
	print(character.name, " DEAD")
	death_texture.visible = true
	target_button.visible = false
	selected_arrow.visible = false
	selected_arrow.focus_mode = Control.FOCUS_NONE
	target_button.focus_mode = Control.FOCUS_NONE
	

func disabled() -> void:
	Functions.set_game_speed(1.0)
	submenu_level = 0
	menu.visible = false
	# attack_menu.visible = false
	selected_arrow.button_pressed = false
	for arrow in get_tree().get_nodes_in_group("selected_arrows"):
		arrow.focus_mode = Control.FOCUS_ALL
	selected_arrow.focus_mode = Control.FOCUS_NONE

func crit_enabled() -> void:
	crits = true

func crit_disabled() -> void:
	crit_off()
	crits = false
	circle_thick.scale = Vector2(0, 0)
	circle_thin.scale = Vector2(0, 0)
	circle_thick.self_modulate = Color(0xffffff)
	circle_thin.self_modulate = Color(0xffffff)
	
func reset_timer(wait_time:float) -> bool:
	if(timer.is_stopped()):
		timer.wait_time = wait_time
		timer.start()
		return true
	else:
		return false

func check_timer() -> bool:
	if(timer.is_stopped()):
		return true
	elif(progress_bar.value > 68 and progress_bar.value < 80):
		timer.stop()
		progress_bar.value = 100
		SignalBus.emit_signal("crits_signal")
		crit_animation()
		return true
	else:
		return false

func ability_pressed(from: Character, ability: Ability) -> void:
	if from == character and check_timer():
		# close_all_menus()
		if crits:
			Functions.set_game_speed(game_slow_speed)
		else:
			Functions.set_game_speed(1.0)
		submenu_level = 3
		if ability.effect == "NEGATIVE":
			for target in get_tree().get_nodes_in_group("selected_targets"):
				if target.visible == true:
					target.texture_focused = TARGET_SELECT
		elif ability.effect == "POSITIVE":
			for target in get_tree().get_nodes_in_group("selected_targets"):
				if target.visible == true:
					target.texture_focused = TARGET_HEAL
		emit_signal("ability_selected", ability, from)
		print(ability.ability_name)

func item_button_pressed(from:Character, item:Item) -> void:
	# close_all_menus()
	submenu_level = 3
	if item.type == "DEBUFF" or item.type == "DAMAGE":
		for target in get_tree().get_nodes_in_group("selected_targets"):
			if target.visible == true:
				target.texture_focused = TARGET_SELECT
	elif item.type == "HEAL" or item.type == "BUFF":
		for target in get_tree().get_nodes_in_group("selected_targets"):
			if target.visible == true:
				target.texture_focused = TARGET_HEAL
	emit_signal("item_selected", from, item)


func _on_selected_arrow_focus_entered() -> void:
	emit_signal("character_selected", character)
	menu.visible = true

func _on_selected_arrow_focus_exited() -> void:
	menu.visible = false

func _on_target_button_pressed() -> void:
	Functions.set_game_speed(1.0)
	if current_action == "ABILITY":
		emit_signal("uses_ability", character, crits)
	elif current_action == "ITEM":
		emit_signal("uses_item", character)
	current_action = ""

func damage_animation(_crit:bool=false) -> void:
	animation_player.play("damage_animation")
	if _crit:
		strong_hit_sound.play()
		Functions.control_shake($PanelContainer, 6, 6, 8, 13, 0.4)
	else:
		hit_sound.play()
		Functions.control_shake($PanelContainer, 3, 3, 5, 10, 0.2)
	


func heal_animation(_crit:bool=false) -> void:
	heal_sound.play()
	pass

func crit_on() -> void:
	if crits == true:
		crit_particles_long_circle.emitting = true
		burning_sound.play()

func crit_off() -> void:
	if crits == true:
		crit_particles_long_circle.emitting = false
		burning_sound.stop()

func _on_target_button_focus_entered() -> void:
	crit_on()

func _on_target_button_focus_exited() -> void:
	crit_off()

func crit_animation() -> void:
	crit_sound.play()
	var tween_c := get_tree().create_tween().set_parallel(true)
	tween_c.tween_property(circle_thick, "scale", Vector2(1, 1), 0.3)
	tween_c.tween_property(circle_thick, "self_modulate", Color(0xffffff00), 0.3)
	var tween_d := get_tree().create_tween().set_parallel(true)
	tween_d.tween_property(circle_thin, "scale", Vector2(1, 1), 0.2)
	tween_d.tween_property(circle_thin, "self_modulate", Color(0xffffff00), 0.2)


# func _on_item_removed(_item:Item) -> void:
# 	reset_items()

# func reset_items() -> void:
# 	for item_button in item_menu.get_children():
# 		item_menu.remove_child(item_button)
# 		item_button.queue_free()

# 	for identifier:StringName in Items.item_list:
# 		var item_button := Button.new()
# 		item_button.text = "%s x%s" % [Items.item_list[identifier].resource.display_name, int(Items.item_list[identifier].total)]
# 		item_button.theme = menu_theme
# 		item_menu.add_child(item_button)
# 		item_button.add_to_group("submenu_item")
# 		item_button.connect("pressed", _on_item_button_pressed.bind(Items.item_list[identifier].resource))

func set_current_action(action:String) -> void:
	current_action = action
