class_name EnemyContainer
extends CharacterContainer

signal uses_ability(target:Character)
signal disable_character(character:Character)

@onready var enemy_photo := %EnemyPhoto
@onready var life_bar := %LifeBar
@onready var death_texture := %DeathTexture
@onready var timer := $Timer
@onready var progress_bar := %ProgressBar
@onready var target_button := %TargetButton
@onready var hit_particles_circle := %HitParticlesCircle
@onready var hit_particles_big_star := %HitParticlesBigStar
@onready var hit_particles_long_circle := %HitParticlesLongCircle
@onready var hit_particles_star := %HitParticlesStar
@onready var heal_particles_long := %HealParticlesLong
@onready var heal_particles_star := %HealParticlesStar
@onready var crit_particles_long_circle := %CritParticlesLongCircle
@onready var burning_sound := %BurningSound
@onready var strong_hit_sound := %StrongHitSound

@onready var hit_sound := %HitSound
@onready var heal_sound := %HealSound

var current_hp := 0.0
var character : Character
var crits := false

func _ready() -> void:
	SignalBus.connect("crits_signal", crit_enabled)
	SignalBus.connect("stop_crit", crit_disabled)

func _process(delta:float) -> void:
	if timer.time_left != 0:
		var value_timer :int = ceil(((timer.wait_time - timer.time_left) / timer.wait_time) * 100)
		progress_bar.value = value_timer

func set_max_life(hp: int) -> void:
	life_bar.max_value = hp
	life_bar.value = hp
	current_hp = hp

func set_health(hp:int, effect:StringName,_crit:bool=false) -> void:
	if effect == "DAMAGE":
		damage_animation(_crit)
	elif effect == "HEAL":
		heal_animation(_crit)
	
	#SignalBus.emit_signal("stop_crit")
	var tween := get_tree().create_tween()
	tween.tween_property(life_bar, "value", hp, 0.5)
	current_hp = hp
	await tween.finished
	print(current_hp, '-', character.name)
	SignalBus.emit_signal("stop_crit")
	if current_hp <= 0:
		emit_signal("disable_character", character)

func set_texture(_texture:Texture) -> void:
	enemy_photo.texture = _texture

func death() -> void:
	print(character.name, " DEAD")
	death_texture.visible = true
	target_button.visible = false
	target_button.focus_mode = Control.FOCUS_NONE

func untargeted() -> void:
	target_button.visible = false
	target_button.focus_mode = Control.FOCUS_NONE

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
	else:
		return false

func selected() -> void:
	target_button.grab_focus()

func _on_target_button_pressed() -> void:
	Functions.set_game_speed(1.0)
	emit_signal("uses_ability", character, crits)
	#crit_off()
	#crits = false

func damage_animation(_crit:bool=false) -> void:
	## TODO: Pasar particulas a Character Resource
	if _crit:
		strong_hit_sound.play()
		Functions.control_shake($VBoxContainer, 6, 6, 8, 13, 0.4)
	else:
		Functions.control_shake($VBoxContainer, 3, 3, 5, 10, 0.2)
	hit_particles_circle.emitting = true
	hit_particles_big_star.emitting = true
	hit_particles_long_circle.emitting = true
	hit_particles_star.emitting = true
	
	## TODO: Pasar custom audio de golpe a Character Resource
	hit_sound.play()

func heal_animation(_crit:bool=false) -> void:
	heal_particles_long.emitting = true
	heal_particles_star.emitting = true
	heal_sound.play()

func crit_enabled() -> void:
	crits = true

func crit_disabled() -> void:
	crit_off()
	crits = false

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
