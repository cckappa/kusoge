extends Control

@onready var selected_button:TextureButton=%SelectedButton
@onready var character_texture:TextureRect=%CharacterTexture
@onready var attacked_texture:TextureRect=%AttackedTexture
@onready var info_vida_text:RichTextLabel=%InfoVidaText
@onready var vida_progress_bar:TextureProgressBar=%VidaProgressBar
@onready var cooldown_progress_bar:TextureProgressBar=%CooldownProgressBar
@onready var timer:=$Timer
@onready var center_control:Control=%CenterControl
@onready var dead_texture:TextureRect=%DeadTexture

var party_character:Character
var can_attack:=true
var dead:=false
var tween :Tween
var displayed_hp:float

func _process(_delta: float) -> void:
	if not timer.is_stopped():
		cooldown_progress_bar.value = (1.0 - (timer.time_left / timer.wait_time)) * 100
		if cooldown_progress_bar.value >66 and cooldown_progress_bar.value < 83:
			can_attack = true
		else:
			can_attack = false

func set_info(_character:Character) -> void:
	party_character = _character
	name = party_character.identifier
	character_texture.texture = party_character.character_portrait
	attacked_texture.texture = party_character.character_damaged
	info_vida_text.text = '[center]'+str(party_character.current_hp)
	displayed_hp = float(party_character.current_hp)

func focus_party_character() -> void:
	selected_button.grab_focus()

func _on_selected_button_pressed() -> void:
	SignalBus.emit_signal("party_character_button_pressed", party_character, self)

func set_health() -> void:
	if tween:
		tween.kill()

	tween = create_tween()

	# var start_hp := int((vida_progress_bar.value / 100.0) * party_character.max_hp)
	var target_hp := party_character.current_hp

	tween.tween_method(func(value: float) -> void:
		displayed_hp = value
		info_vida_text.text = "[center]" + str(int(value))
		vida_progress_bar.value = int((value / float(party_character.max_hp)) * 100)
	, float(displayed_hp), float(target_hp), 0.5)

func set_cooldown(_time:float) -> void:
	can_attack = false
	timer.wait_time = _time
	timer.start()

func _on_timer_timeout() -> void:
	can_attack = true

func get_crit() -> bool:
	if cooldown_progress_bar.value >66 and cooldown_progress_bar.value < 83:
		timer.stop()
		cooldown_progress_bar.value = 100
		return true
	else:
		return false

func kill_party_character() -> void:
	dead = true
	SignalBus.emit_signal("party_character_killed")
	character_texture.modulate = Color(0.107, 0.107, 0.107)
	selected_button.focus_mode = Control.FOCUS_NONE
	dead_texture.visible = true

func attacked() -> void:
	character_texture.visible = false
	attacked_texture.visible = true
	attacked_texture.modulate = Color(5.472, 5.472, 5.472)

	var _tween := create_tween()
	_tween.tween_property(attacked_texture, "modulate", Color(1, 1, 1, 1), 0.3)

	await get_tree().create_timer(0.3).timeout
	Functions.set_game_speed(0.05)
	await get_tree().create_timer(0.005).timeout
	Functions.set_game_speed(1)

	attacked_texture.visible = false
	attacked_texture.modulate = Color.WHITE
	character_texture.visible = true
# func attacked() -> void:
# 	character_texture.visible = false
# 	attacked_texture.visible = true
# 	await get_tree().create_timer(0.2).timeout
# 	attacked_texture.visible = false
# 	character_texture.visible = true
