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
@onready var portrait := %Portrait
@onready var portrait_damaged := %PortraitDamaged
@onready var life_bar := %LifeBar
@onready var health_points := %HealthPoints
@onready var selected_arrow := %SelectedArrow
@onready var ability_arrow := %AbilityArrow
@onready var fake_arrow:= %FakeArrow
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
var character_portrait_damaged :  Texture
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
var talking:bool=false


func _ready() -> void:
	# SignalBus.connect("item_removed", _on_item_removed)
	SignalBus.connect("action_selected", set_current_action)
	SignalBus.connect("starts_talking", _on_starts_talking)
	SignalBus.connect("stops_talking", _on_stops_talking)
	portrait.texture = character_portrait
	portrait_damaged.texture = character_portrait_damaged
	damage_value.visible = false
	ability_arrow.select_arrow(arrange_position, "ally")
	reverb_effect = AudioServer.get_bus_effect(bus_index, 1) as AudioEffectReverb
	SignalBus.connect("crits_signal", crit_enabled)
	SignalBus.connect("stop_crit", crit_disabled)
	SignalBus.connect("attack_menu_opened", unfocus_arrows)
	SignalBus.connect("item_menu_opened", unfocus_arrows)
	SignalBus.connect("menu_closed", focus_current_character)
	SignalBus.connect("ability_button_pressed", ability_pressed)
	SignalBus.connect("item_button_pressed", item_button_pressed)

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

func hide_fake_arrow() -> void:
	fake_arrow.visible = false

func death() -> void:
	print(character.name, " DEAD")
	portrait_damaged.modulate = Color.hex(0x282331FF)
	portrait_damaged.visible = true
	portrait.visible = false
	target_button.visible = false
	selected_arrow.visible = false
	selected_arrow.focus_mode = Control.FOCUS_NONE
	target_button.focus_mode = Control.FOCUS_NONE
	

func disabled() -> void:
	# Functions.set_game_speed(1.0)
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
		var p_tween := get_tree().create_tween()
		p_tween.tween_property(progress_bar, "value", 100.0, 0.01)
		SignalBus.emit_signal("crits_signal")
		crit_animation()
		return true
	else:
		return false

func ability_pressed(from: Character, ability: Ability) -> void:
	if from == character:
		if check_timer():
			fake_arrow.visible = true
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
		else:
			var tween := create_tween()
			tween.tween_property(progress_bar, "modulate", Color.hex(0xff5c47ff), 0.01)
			tween.tween_property(progress_bar, "modulate", Color(0,1.65,3.15,1), 0.01)
			tween.tween_property(progress_bar, "modulate", Color.hex(0xff5c47ff), 0.02)
			tween.tween_property(progress_bar, "modulate", Color(0,1.65,3.15,1), 0.02)

			var tween2 := create_tween()
			tween2.tween_property(progress_bar, "scale", Vector2(1.15, 1.15), 0.01)
			tween2.tween_property(progress_bar, "scale", Vector2(0.8, 0.8), 0.01)
			tween2.tween_property(progress_bar, "scale", Vector2(1.15, 1.15), 0.02)
			tween2.tween_property(progress_bar, "scale", Vector2(0.8, 0.8), 0.02)

			var tween3 := create_tween()
			tween3.tween_property(portrait, "modulate", Color.hex(0xff5c47ff), 0.01)
			tween3.tween_property(portrait, "modulate", Color.hex(0xffffffff), 0.01)
			tween3.tween_property(portrait, "modulate", Color.hex(0xff5c47ff), 0.02)
			tween3.tween_property(portrait, "modulate", Color.hex(0xffffffff), 0.02)

			SignalBus.emit_signal("ability_cooldown_not_finished")

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
	if not talking:
		menu.visible = true

func _on_selected_arrow_focus_exited() -> void:
	menu.visible = false

func _on_target_button_pressed() -> void:
	# Functions.set_game_speed(1.0)
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

func target_focus() -> void:
	target_button.focus_mode = Control.FOCUS_ALL

func set_current_action(action:String) -> void:
	current_action = action

func _on_starts_talking() -> void:
	timer.paused = true
	talking = true
	menu.visible = false
	selected_arrow.visible = false

func _on_stops_talking() -> void:
	timer.paused = false
	talking = false
	selected_arrow.visible = true
