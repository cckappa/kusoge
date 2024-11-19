extends BattleState

@export var character_portraits:HBoxContainer
@export var enemy_photo:TextureRect

var character_containers : Array[CharacterContainer]
var character_container_size := Vector2(125, 0)

func enter(previous_state_path: String, data := {}) -> void:
	add_characters()
	black_rect.visible = true
	await Functions.fade_color_rect(black_rect, "OUT", 2)
	finished.emit(DECIDING)

func add_characters() -> void:
	for character in Globals.party:
		# CharacterContainer
		var character_container := CharacterContainer.new()
		character_container.name = character.name
		character_container.size = character_container_size
		character_container.front_texture = character.character_front
		character_container.character = character
		character_portraits.add_child(character_container)
		
		#TextureRect
		var character_texture := TextureRect.new()
		character_texture.texture = character.character_portrait
		character_container.add_child(character_texture)
		
		#LifeContainer
		var life_container := HBoxContainer.new()
		life_container.name = "LifeContainer"
		life_container.alignment = BoxContainer.ALIGNMENT_CENTER
		character_container.add_child(life_container)
		
		#LifeRects
		var rect_size_x : int = ceil(character_container.size.x/character.max_hp)

		for hp in character.current_hp:
			var life_rect := ColorRect.new()
			life_rect.color = Color(0.459, 1, 0.325)
			life_rect.size = Vector2(rect_size_x, 20)
			life_rect.custom_minimum_size = Vector2(rect_size_x, 20)
			life_container.add_child(life_rect)

func add_main_enemy() -> void:
	enemy_photo.texture = Globals.main_enemy.portrait
