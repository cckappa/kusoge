extends LimboState

@onready var enemies_h_box_container:=%EnemiesHBoxContainer
@onready var demo_tecnico_boss:=%DemoTecnicoBoss
@onready var enemy_control:=%EnemyControl
@onready var center_container:=%CenterContainer

const ENEMY_CONTAINER_PATH:="res://scenes/battle/enemy_containers/enemy_basic_container.tscn"

func _setup() -> void:
	blackboard.set_var("special_battle", _check_battle_type())
	_free_children()

	if blackboard.get_var("special_battle"):
		set_special_battle()
	else:
		set_normal_battle()


func set_special_battle() -> void:
	var enemy_container_scene := load(Globals.enemies[0].enemy_container_path) as PackedScene
	var enemy_container := enemy_container_scene.instantiate()
	enemy_control.add_child(enemy_container)
	# const enemy_container := preload(Globals.enemies[0].enemy_container_path)
	# enemy_control.add_child(enemy_container)

func set_normal_battle() -> void:
	const enemy_container := preload(ENEMY_CONTAINER_PATH)

	var i:=0

	for enemy in Globals.enemies:
		var enemy_instance := enemy_container.instantiate()
		enemies_h_box_container.add_child(enemy_instance)
		enemy_instance.call_deferred("set_info", enemy)

	await get_tree().process_frame
	enemies_h_box_container.size = Vector2(0,0)


# 	var first_enemy_container:PanelContainer
# 	var last_enemy_container:PanelContainer

# 	var i:=0

# 	# for character in Globals.current_characters:
# 	# 	var enemy_instance := enemy_container.instantiate()
# 	# 	enemies_h_box_container.add_child(enemy_instance)
# 	# 	enemy_instance.call_deferred("set_info",character)

# 	# 	if Globals.current_characters.size() > 1:
# 	# 		if i==0:
# 	# 			await get_tree().process_frame
# 	# 			first_party_character_container = party_character_instance
# 	# 		elif i == Globals.current_characters.size() - 1:
# 	# 			await get_tree().process_frame
# 	# 			last_party_character_container = party_character_instance
			
# 	# 		i += 1
	
# 	# if Globals.current_characters.size() > 1:
# 	# 	first_party_character_container.selected_button.focus_neighbor_left = last_party_character_container.selected_button.get_path()
# 	# 	last_party_character_container.selected_button.focus_neighbor_right = first_party_character_container.selected_button.get_path()

func _free_children() -> void:
	demo_tecnico_boss.queue_free()
	if blackboard.get_var("special_battle") == true:
		center_container.queue_free()
	else:
		for child in enemies_h_box_container.get_children():
			child.queue_free()


func _check_battle_type() -> bool:
	var is_special := false
	for enemy in Globals.enemies:
		if enemy.special_enemy == true:
			is_special = true
	return is_special
