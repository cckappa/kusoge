class_name EnemyBattleClass
extends Node

@export var enemy_resource:EnemyResource=null
@export var enemy_texture:Control
@export var enemy_button:TextureButton
@export var info_vida_text:RichTextLabel
@export var control_center:Control
@export var vida_progress_bar:TextureProgressBar
@export var damage_number:RichTextLabel
@export var death_texture:TextureRect
@export var b_t_player:BTPlayer

var dead:=false
var current_alive_allies_containers:Array
var ready_scene := false
var current_ability:Ability
var current_target:PanelContainer
var tween :Tween

func _ready() -> void:
	enemy_button.connect("pressed", _on_button_pressed)
	SignalBus.connect("set_alive_allies_containers", _on_set_alive_allies_containers)
	b_t_player.blackboard.set_var("agent", self)
	_setup()

func _setup() -> void:
	pass

func focus_enemy() -> bool:
	if enemy_resource.disabled != true:
		enemy_button.grab_focus()

	return !enemy_resource.disabled

func set_info(_enemy_resource:EnemyResource) -> void:
	if _enemy_resource != null:
		enemy_resource = _enemy_resource
	info_vida_text.text = "[center]" + str(enemy_resource.max_hp)
	if enemy_texture.is_class("TextureRect"):
		enemy_texture.texture = enemy_resource.character_portrait

func _on_button_pressed() -> void:
	SignalBus.emit_signal("enemy_button_pressed", enemy_resource, control_center, self)

func set_health() -> void:
	if tween:
		tween.kill()

	tween = create_tween()

	var start_hp := int((vida_progress_bar.value / 100.0) * enemy_resource.max_hp)
	var target_hp := enemy_resource.current_hp

	tween.tween_method(func(value: float) -> void:
		info_vida_text.text = "[center]" + str(int(value))
		vida_progress_bar.value = int((value / float(enemy_resource.max_hp)) * 100)
	, float(start_hp), float(target_hp), 0.5)


func show_damage(damage:float) -> void:
	if dead:
		return
	damage_number.text = "[center]" + str(ceili(damage))
	damage_number.visible = true
	damage_number.modulate.a = 1
	var start_pos := damage_number.position
	var end_pos := start_pos + Vector2(randf_range(-60, 60), randf_range(-80, -40))
	
	# Control point pushes the path into an arc shape
	var control := Vector2(
		(start_pos.x + end_pos.x) / 2 + randf_range(-30, 30),
		(start_pos.y + end_pos.y) / 2 - randf_range(20, 50)
	)
	
	var duration := 1.0
	var _tween := create_tween()
	
	_tween.tween_method(func(t: float) -> void:
		# Quadratic bezier position
		var pos := start_pos.lerp(control, t).lerp(control.lerp(end_pos, t), t)
		damage_number.position = pos
		
		# Derivative of bezier gives the direction to rotate toward
		var tangent := (control - start_pos).lerp(end_pos - control, t)
		damage_number.rotation = tangent.angle() * 0.05  # 0.05 keeps the tilt subtle
	, 0.0, 1.0, duration)
	
	# Fade out at the end
	_tween.parallel().tween_property(damage_number, "modulate:a", 0.0, duration)
	await _tween.finished
	damage_number.visible = false
	damage_number.position = start_pos

func kill_enemy() -> void:
	dead = true
	death_texture.visible = true
	enemy_texture.modulate = Color(0.107, 0.107, 0.107)
	enemy_button.focus_mode = Control.FOCUS_NONE

func is_alive() -> bool:
	return !dead

func _on_set_alive_allies_containers(_alive_allies_containers:Array) -> void:
	current_alive_allies_containers = _alive_allies_containers

func can_use_ability() -> bool:
	return enemy_resource != null and enemy_resource.abilities.size() > 0 and current_alive_allies_containers.size() > 0

func use_ability() -> void:
	current_ability = enemy_resource.abilities.pick_random()
	if current_alive_allies_containers.size() == 0:
		return
	
	current_target = current_alive_allies_containers.pick_random()
	
	var animation_instance := current_ability.attack_animation.instantiate()
	animation_instance.rotation_degrees = -180
	animation_instance.connect("landed_ability", landed_ability.bind(current_ability, current_target.party_character, current_target))
	current_target.center_control.add_child(animation_instance)


func landed_ability(ability:Ability, target:Character, party_container:PanelContainer) -> void:
	print("Enemy landed ability: ", ability.ability_name, " on target: ", target.name)
	# target.take_damage(ability.damage_points)
	# party_container.show_damage(current_ability.use_ability(current_target.party_character, false))
	ability.use_ability(target, false)
	if target.disabled:
		party_container.kill_party_character()
	current_target.set_health()
	current_target.attacked()
