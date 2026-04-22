extends LimboState

@onready var attack_menu_control:=%AttackMenuControl
@onready var header_bar:=%HeaderBar
@onready var info_habilidades_v_box:=%InfoHabilidadesVBox
@onready var habilidad_dano:=%HabilidadDano
@onready var habilidad_segundos:=%HabilidadSegundos

var selected_party_member:Character

const ATTACK_MENU_CONTAINER:= "res://scenes/battle/attack_menu_container.tscn"

func _setup() -> void:
	_free_children()
	SignalBus.connect("attack_menu_focused", _on_attack_menu_focused)
	SignalBus.connect("attack_menu_pressed", _on_attack_menu_pressed)
	SignalBus.connect("enemies_defeated", _enemies_defeated)
	attack_menu_control.visible = false

func _enter() -> void:
	_free_children()
	Functions.set_game_speed(0.5)
	selected_party_member = blackboard.get_var("selected_party_member")

	header_bar.set_title_text(selected_party_member.name)
	const attack_menu_container = preload(ATTACK_MENU_CONTAINER)

	var first_ability_container:HBoxContainer
	var last_ability_container:HBoxContainer
	var i:=0

	for ability in selected_party_member.abilities:
		var attack_menu_container_instance := attack_menu_container.instantiate()
		info_habilidades_v_box.add_child(attack_menu_container_instance)
		attack_menu_container_instance.set_info(ability)

		if selected_party_member.abilities.size() > 1:
			if i == 0:
				await get_tree().process_frame
				first_ability_container = attack_menu_container_instance
			elif i == selected_party_member.abilities.size() - 1:
				await get_tree().process_frame
				last_ability_container = attack_menu_container_instance
		
		i += 1

	if selected_party_member.abilities.size() > 1:
		first_ability_container.selected_button.focus_neighbor_top = last_ability_container.selected_button.get_path()
		last_ability_container.selected_button.focus_neighbor_bottom = first_ability_container.selected_button.get_path()

	info_habilidades_v_box.get_child(0).selected_button.call_deferred("grab_focus")
	attack_menu_control.visible = true


func _input(event:InputEvent) -> void:
	if event.is_action_pressed("back") and is_active():
		dispatch("to_focus_party")

func _free_children() -> void:
	for child in info_habilidades_v_box.get_children():
		child.queue_free()
		
func _on_attack_menu_focused(_ability:Ability) -> void:
	if _ability.effect == "NEGATIVE":
		_ability = _ability as DamageAbility
		habilidad_dano.text = " " + str(_ability.damage_points) + " "
		habilidad_segundos.text = str(_ability.wait_time) + "s"
	else:
		_ability = _ability as HealAbility
		habilidad_dano.text = " " + str(_ability.heal_points) + " "
		habilidad_segundos.text = str(_ability.wait_time) + "s"

func _on_attack_menu_pressed(_ability:Ability) -> void:
	if is_active() and blackboard.get_var("selected_party_container").can_attack:
		dispatch("to_focus_enemy", _ability)

func _exit() -> void:
	attack_menu_control.visible = false
	Functions.set_game_speed(1)

func _enemies_defeated() -> void:
	if is_active():
		dispatch("to_win_state")
