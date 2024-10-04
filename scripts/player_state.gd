class_name PlayerState
extends State

var player:PlayableCharacter

func _ready() -> void:
	await owner.ready
	player = owner as PlayableCharacter
	print(player.character_info.run_speed)
