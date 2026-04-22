extends Control

@onready var selected_button:TextureButton=%SelectedButton
@onready var character_texture:TextureRect=%CharacterTexture
@onready var info_vida_text:RichTextLabel=%InfoVidaText
@onready var vida_progress_bar:TextureProgressBar=%VidaProgressBar
@onready var cooldown_progress_bar:TextureProgressBar=%CooldownProgressBar
@onready var timer:=$Timer

var party_character:Character
var can_attack:=true

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
	info_vida_text.text = '[center]'+str(party_character.current_hp)

func focus_party_character() -> void:
	selected_button.grab_focus()

func _on_selected_button_pressed() -> void:
	SignalBus.emit_signal("party_character_button_pressed", party_character, self)

func set_health() -> void:
	var tween := create_tween()

	var start_hp := int((vida_progress_bar.value / 100.0) * party_character.max_hp)
	var target_hp := party_character.current_hp

	tween.tween_method(func(value: float) -> void:
		info_vida_text.text = "[center]" + str(int(value))
		vida_progress_bar.value = int((value / float(party_character.max_hp)) * 100)
	, float(start_hp), float(target_hp), 0.5)

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
