extends BattleContainer

@onready var selected_button:TextureButton=%SelectedButton
@onready var character_texture:TextureRect=%CharacterTexture
@onready var attacked_texture:TextureRect=%AttackedTexture
@onready var info_vida_text:RichTextLabel=%InfoVidaText
@onready var vida_progress_bar:TextureProgressBar=%VidaProgressBar
@onready var cooldown_progress_bar:TextureProgressBar=%CooldownProgressBar
@onready var timer:=$Timer
@onready var center_control:Control=%CenterControl
@onready var dead_texture:TextureRect=%DeadTexture
@onready var damage_number:RichTextLabel=%DamageNumber
@onready var hitsound:AudioStreamPlayer=$HitSound
@onready var critsound:AudioStreamPlayer=$CritSound

# var party_character:Character
var can_attack:=true
var dead:=false
var tween :Tween
var displayed_hp:float
var cooldown_tween: Tween

func _process(_delta: float) -> void:
	if not timer.is_stopped():
		cooldown_progress_bar.value = (1.0 - (timer.time_left / timer.wait_time)) * 100
		if cooldown_progress_bar.value >66 and cooldown_progress_bar.value < 83:
			can_attack = true
		else:
			can_attack = false

func set_info(_character:Character) -> void:
	if _character == null:
		return

	character_resource = _character
	name = character_resource.identifier
	character_texture.texture = character_resource.character_portrait
	attacked_texture.texture = character_resource.character_damaged
	info_vida_text.text = '[center]'+str(character_resource.current_hp)
	displayed_hp = float(character_resource.current_hp)
	vida_progress_bar.value = displayed_hp / float(character_resource.max_hp) * 100

func focus_party_character() -> bool:
	selected_button.grab_focus()
	return true

func _on_selected_button_pressed() -> void:
	SignalBus.emit_signal("party_character_button_pressed", character_resource, self)

func set_health() -> void:
	if tween:
		tween.kill()

	tween = create_tween()

	# var start_hp := int((vida_progress_bar.value / 100.0) * party_character.max_hp)
	var target_hp := character_resource.current_hp

	tween.tween_method(func(value: float) -> void:
		displayed_hp = value
		info_vida_text.text = "[center]" + str(int(value))
		vida_progress_bar.value = int((value / float(character_resource.max_hp)) * 100)
	, float(displayed_hp), float(target_hp), 0.5)


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

func set_cooldown(_time:float) -> void:
	can_attack = false
	timer.wait_time = _time
	timer.start()

func _on_timer_timeout() -> void:
	cooldown_progress_bar.modulate = Color(0.0, 1.657, 3.15)
	can_attack = true

func get_crit() -> bool:
	if cooldown_progress_bar.value >66 and cooldown_progress_bar.value < 83:
		timer.stop()
		cooldown_progress_bar.value = 100
		critsound.play()
		cooldown_progress_bar.modulate = Color(0.0, 1.657, 3.15)
		return true
	else:
		return false

func kill_character() -> void:
	dead = true
	SignalBus.emit_signal("party_character_killed")
	character_texture.modulate = Color(0.107, 0.107, 0.107)
	selected_button.focus_mode = Control.FOCUS_NONE
	dead_texture.visible = true

func is_alive() -> bool:
	return !dead

func show_attacked() -> void:
	hitsound.play()
	character_texture.visible = false
	attacked_texture.visible = true
	attacked_texture.modulate = Color(5.472, 5.472, 5.472)

	var _tween := create_tween()
	_tween.tween_property(attacked_texture, "modulate", Color(1, 1, 1, 1), 0.4)

	await get_tree().create_timer(0.4).timeout

	attacked_texture.visible = false
	attacked_texture.modulate = Color.WHITE
	character_texture.visible = true

func _on_selected_button_focus_entered() -> void:
	SignalBus.emit_signal("party_character_button_focused", self)

func play_cooldown_animation() -> void:
	if cooldown_tween:
		cooldown_tween.kill()
	cooldown_tween = create_tween().set_loops(3)
	cooldown_tween.tween_property(cooldown_progress_bar, "modulate", Color.RED, 0.05)
	cooldown_tween.tween_property(cooldown_progress_bar, "modulate", Color.WHITE, 0.05)

func stop_cooldown_animation() -> void:
	if cooldown_tween:
		cooldown_tween.kill()
		cooldown_tween = null
	cooldown_progress_bar.modulate = Color(0.0, 1.657, 3.15)

func set_cooldown_color() -> void:
	if timer.is_stopped():
		cooldown_progress_bar.modulate = Color(0.0, 1.657, 3.15)
	else:
		cooldown_progress_bar.modulate = Color.WHITE
