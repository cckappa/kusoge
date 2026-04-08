@tool
extends BaseScene

@export var door_sprite : AnimatedSprite2D
@export var door_collision : CollisionShape2D

@onready var door_animation_player:= %DoorAnimationPlayer
@onready var talk_door:= %TalkDoor

var battle_scene: String = "res://scenes/battle.tscn" 

func _ready_scene() -> void:

	match Globals.maps[single_map_resource.map_name].state:
		"default":
			pass
		"door_opened":
			door_sprite.play("fully_opened")
			door_collision.disabled = true
			talk_door.get_child(0).monitoring = false
		_:
			pass

	black_rect.visible = true
	await Functions.fade_color_rect(black_rect, "OUT", 2)


func start_battle() -> void:
	get_tree().change_scene_to_file(battle_scene)


func _on_area_2d_body_entered(body: Node) -> void:
	if body.is_in_group("main_character") and Globals.maps[single_map_resource.map_name].state == "default":
		if (Globals.key_variables.has("demo_tecnico_hub-batalla_1") and Globals.key_variables["demo_tecnico_hub-batalla_1"] == true) \
		and (Globals.key_variables.has("demo_tecnico_hub-batalla_2") and Globals.key_variables["demo_tecnico_hub-batalla_2"] == true) \
		and (Globals.key_variables.has("demo_tecnico_hub-batalla_3") and Globals.key_variables["demo_tecnico_hub-batalla_3"] == true):
			door_animation_player.play("opening")
			Globals.maps[single_map_resource.map_name].state = "door_opened"
			

func play_opened_animation() -> void:
	door_sprite.play("opened")
