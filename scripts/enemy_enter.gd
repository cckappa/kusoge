extends BattleStateEnemy

@export var enemy_portraits:HBoxContainer

const ENEMY_CONTAINER = preload("res://scenes/enemy_container.tscn")

func enter(previous_state_path: String, data := {}) -> void:
	pass
	#set_current_enemies()
	#shuffle_enemies_abilities()
	#add_enemies()
#
	#finished.emit(DECIDING)

func set_current_enemies() -> void:
	Globals.current_arrange_enemies.joypad_1 = Globals.enemies[0]
	Globals.current_arrange.joypad_1 = Globals.enemies[0]
	
	if Globals.enemies.size() > 1 and Globals.enemies[1] != null:
		Globals.current_arrange_enemies.joypad_2 = Globals.enemies[1]
		Globals.current_arrange.joypad_2 = Globals.enemies[1]
	if Globals.enemies.size() > 2 and Globals.enemies[2] != null:
		Globals.current_arrange_enemies.joypad_3 = Globals.enemies[2]
		Globals.current_arrange.joypad_3 = Globals.enemies[2]
	if Globals.enemies.size() > 3 and Globals.enemies[3] != null:
		Globals.current_arrange_enemies.joypad_4 = Globals.enemies[3]
		Globals.current_arrange.joypad_4 = Globals.enemies[3]


func shuffle_enemies_abilities() -> void:
	for enemy:Character in Globals.current_arrange_enemies.values():
		if enemy != null:
			shuffle_abilities(enemy)

func add_enemies() -> void:
	var key:int=0
	for enemy:Character in Globals.current_arrange_enemies.values():
		if enemy != null:
			var enemy_container := ENEMY_CONTAINER.instantiate()
			enemy_container.character = enemy
			enemy_container.name = enemy.name
			enemy_container.arrange_position = key
			enemy_portraits.add_child(enemy_container)
			enemy.current_container = enemy_container
			enemy_container.set_texture(enemy.character_portrait)
			enemy_container.set_max_life(enemy.max_hp)
			key = key + 1

func shuffle_abilities(member:Character) -> void:
	member.current_abilities = member.abilities.duplicate(true)
	member.current_abilities.shuffle()
	member.current_abilities = member.current_abilities.slice(0, 2)
