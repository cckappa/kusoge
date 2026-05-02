extends LimboState

@onready var enemies_h_box_container:=%EnemiesHBoxContainer
@onready var enemy_control:=%EnemyControl

var selected_party_container:PanelContainer
var selected_ability:Ability
var crit:=false

func _ready() -> void:
	SignalBus.connect("enemy_button_pressed", _on_enemy_button_pressed)
	SignalBus.connect("enemies_defeated", _enemies_defeated)
	SignalBus.connect("set_alive_allies_containers", _on_set_alive_allies_containers)
	SignalBus.connect("total_party_kill", _on_total_party_kill)

func _enter() -> void:
	selected_ability = get_cargo()
	if blackboard.get_var("crit") == false:
		blackboard.set_var("crit", blackboard.get_var("selected_party_container").get_crit())
	crit = blackboard.get_var("crit")
	
	if blackboard.get_var("special_battle"):
		enemy_control.get_child(0).get_child(0).focus_enemy()
	else:
		for enemy in enemies_h_box_container.get_children():
			if enemy.focus_enemy():
				return

func _input(event:InputEvent) -> void:
	if event.is_action_pressed("back") and is_active():
		dispatch("to_focus_attack")

func _on_enemy_button_pressed(_enemy_resource:Character, _control:Control, _enemy_container:EnemyBattleClass) -> void:
	if is_active():
		selected_party_container = blackboard.get_var("selected_party_container")
		selected_party_container.set_cooldown(selected_ability.ability_effect.wait_time)
		selected_party_container.set_cooldown_color()

		var animation_instance:Node = selected_ability.ability_effect.attack_animation.instantiate()
		animation_instance.connect("landed_ability", landed_ability.bind(selected_ability, _enemy_resource, _enemy_container))
		_control.add_child(animation_instance)
		dispatch("to_focus_party")

func landed_ability(ability:Ability, target:Character, enemy_container:EnemyBattleClass) -> void:
	print("Landed ability: ", ability.ability_effect.ability_name, " on target: ", target.name, " with crit: ", crit)
	ability.ability_effect.use_ability(target, enemy_container, crit)
	# if target.disabled:
	# 	enemy_container.kill()

	# enemy_container.set_health()
	emit_enemies_defeated()

func emit_enemies_defeated() -> void:
	var all_enemies_defeated := true
	for enemy in enemies_h_box_container.get_children():
		if enemy.is_alive():
			all_enemies_defeated = false

	if all_enemies_defeated:
		SignalBus.emit_signal("enemies_defeated")

func _enemies_defeated() -> void:
	if is_active():
		dispatch("to_win_state")

func _on_set_alive_allies_containers(alive_allies_containers:Array) -> void:
	if alive_allies_containers.size() > 0 and is_active():
		if not blackboard.get_var("selected_party_container").is_alive():
			await get_tree().process_frame
			dispatch("to_focus_party")

func _on_total_party_kill() -> void:
	if is_active():
		dispatch("to_lose_state")
