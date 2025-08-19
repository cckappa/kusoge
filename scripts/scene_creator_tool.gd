@tool
extends Node
class_name SceneCreatorTool

@export_tool_button("Create Scene")
var create_scene_button: = create_scene
var playable_character: Node
var camera_manager: Node
var collision_shape_2d_base: Node2D

func create_scene() -> void:
	if Engine.is_editor_hint():
		print('Creating scene...')

		if not get_parent().has_node("ParallaxBackgroundLayer"):
			print('1. Creating ParallaxBackgroundLayer...')
			var parallax_background_layer := ParallaxBackgroundLayer.new()
			parallax_background_layer.name = "ParallaxBackgroundLayer"
			get_parent().add_child(parallax_background_layer)
			parallax_background_layer.owner = get_tree().edited_scene_root

		if not get_parent().has_node("BackgroundLayer"):
			print('2. Creating BackgroundLayer...')
			var background_layer := BackgroundLayer.new()
			background_layer.name = "BackgroundLayer"
			get_parent().add_child(background_layer)
			background_layer.owner = get_tree().edited_scene_root

		if not get_parent().has_node("PlayableCharacter"):
			print('3. Creating PlayableCharacter...')
			var playable_character_scene := load("res://scenes/playable_character.tscn")
			playable_character = playable_character_scene.instantiate()
			get_parent().add_child(playable_character)
			playable_character.owner = get_tree().edited_scene_root

		if not get_parent().has_node("NpcLayer"):
			print('4. Creating NpcLayer...')
			var npc_layer := NpcLayer.new()
			npc_layer.name = "NpcLayer"
			get_parent().add_child(npc_layer)
			npc_layer.owner = get_tree().edited_scene_root

		if not get_parent().has_node("ObjectLayer"):
			print('5. Creating ObjectLayer...')
			var object_layer := ObjectLayer.new()
			object_layer.name = "ObjectLayer"
			get_parent().add_child(object_layer)
			object_layer.owner = get_tree().edited_scene_root
		
		if not get_parent().has_node("EnemiesLayer"):
			print('6. Creating EnemiesLayer...')
			var enemies_layer := EnemiesLayer.new()
			enemies_layer.name = "EnemiesLayer"
			get_parent().add_child(enemies_layer)
			enemies_layer.owner = get_tree().edited_scene_root

		if not get_parent().has_node("SavesLayer"):
			print('7. Creating SavesLayer...')
			var saves_layer := SavesLayer.new()
			saves_layer.name = "SavesLayer"
			get_parent().add_child(saves_layer)
			saves_layer.owner = get_tree().edited_scene_root

		if not get_parent().has_node("CanvasLayer"):
			print('8. Creating CanvasLayer...')
			var canvas_layer := CanvasLayer.new()
			canvas_layer.name = "CanvasLayer"
			get_parent().add_child(canvas_layer)
			canvas_layer.owner = get_tree().edited_scene_root

		if get_parent().has_node("CanvasLayer"):
			if not get_parent().get_node("CanvasLayer").has_node("PauseMenu"):
				print('8.1 Creating Pause Menu...')
				var pause_menu_scene := load("res://scenes/pause_menu.tscn")
				var pause_menu: Node = pause_menu_scene.instantiate()
				get_parent().get_node("CanvasLayer").add_child(pause_menu)
				pause_menu.owner = get_tree().edited_scene_root
			
			if not get_parent().get_node("CanvasLayer").has_node("SettingsMenu"):
				print('8.2 Creating Settings Menu...')
				var settings_menu_scene := load("res://scenes/settings_menu.tscn")
				var settings_menu: Node = settings_menu_scene.instantiate()
				get_parent().get_node("CanvasLayer").add_child(settings_menu)
				settings_menu.owner = get_tree().edited_scene_root
			
			if not get_parent().get_node("CanvasLayer").has_node("BlackRect"):
				print('8.3 Creating Black Rect...')
				var black_rect_scene := load("res://scenes/black_rect.tscn")
				var black_rect: Node = black_rect_scene.instantiate()
				get_parent().get_node("CanvasLayer").add_child(black_rect)
				black_rect.owner = get_tree().edited_scene_root

		if not get_parent().has_node("AudioStreamPlayer"):
			print('9. Creating AudioStreamPlayer...')
			var audio_stream_player := AudioStreamPlayer.new()
			audio_stream_player.name = "AudioStreamPlayer"
			get_parent().add_child(audio_stream_player)
			audio_stream_player.owner = get_tree().edited_scene_root

		if not get_parent().has_node("CameraManager"):
			print('10. Creating Camera Manager...')
			camera_manager = load("res://scenes/camera_manager.tscn").instantiate()
			camera_manager.name = "CameraManager"
			get_parent().add_child(camera_manager)
			camera_manager.owner = get_tree().edited_scene_root

   
			get_tree().edited_scene_root.set_editable_instance(camera_manager, true)

		print('Scene Created')
