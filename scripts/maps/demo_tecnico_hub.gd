extends BaseScene

@export var door_sprite : AnimatedSprite2D
@export var door_collision : CollisionShape2D

@onready var door_animation_player:= %DoorAnimationPlayer
@onready var talk_door:= %TalkDoor

var battle_scene: String = "res://scenes/battle.tscn" 

func _ready_scene() -> void:
	SignalBus.connect("wild_enemy_encounter", setup_battle)

	match Globals.maps.demo_tecnico_hub.state:
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

func setup_battle() -> void:
	audio_stream_player.set("parameters/switch_to_clip", "EnemyEncounter")
	black_rect.visible = true
	print("Setting up battle...")

	await Functions.fade_color_rect(black_rect, "IN", 0.5)
	call_deferred("start_battle")

func start_battle() -> void:
	get_tree().change_scene_to_file(battle_scene)


func _on_area_2d_body_entered(body: Node) -> void:
	if body.is_in_group("main_character") and Globals.maps.demo_tecnico_hub.state == "default":
		if (Globals.key_variables.has("demo_tecnico_hub-batalla_1") and Globals.key_variables["demo_tecnico_hub-batalla_1"] == "victory") \
		and (Globals.key_variables.has("demo_tecnico_hub-batalla_2") and Globals.key_variables["demo_tecnico_hub-batalla_2"] == "victory") \
		and (Globals.key_variables.has("demo_tecnico_hub-batalla_3") and Globals.key_variables["demo_tecnico_hub-batalla_3"] == "victory"):
			door_animation_player.play("opening")
			Globals.maps.demo_tecnico_hub.state = "door_opened"
			

func play_opened_animation() -> void:
	door_sprite.play("opened")
