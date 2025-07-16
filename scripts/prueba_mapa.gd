extends BaseScene

@export var black_rect : ColorRect

# var battle_scene: String = "res://scenes/battle.tscn" 

func _ready_scene() -> void:
	SignalBus.connect("wild_enemy_encounter", setup_battle)
	black_rect.visible = true
	await Functions.fade_color_rect(black_rect, "OUT", 2)

func setup_battle() -> void:
	audio_stream_player.set("parameters/switch_to_clip", "EnemyEncounter")
	black_rect.visible = true

	await Functions.fade_color_rect(black_rect, "IN", 0.5)
	call_deferred("start_battle")

# func start_battle() -> void:
	# get_tree().change_scene_to_file(battle_scene)
