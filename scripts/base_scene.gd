@tool
class_name BaseScene
extends Node2D

@export_tool_button("Add to Maps Resource")
var add_to_maps_button:= add_to_maps_resource

## SingleMapResource to set map information on the inspector
@export var single_map_resource: SingleMapResource
@export var room_state: String = "default"

@export_tool_button("Export Map")
var export_map_button:= export_map_image

@onready var background_layer:BackgroundLayer = $BackgroundLayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var black_rect: ColorRect = $CanvasLayer/BlackRect

# var battle_scene: String = "res://scenes/battle.tscn" 
const BATTLE = preload("res://scenes/battle.tscn")
const FULL_MAPS_RESOURCE_PATH = "res://assets/resources/maps/full_maps.tres"
const EMPTY_DIALOGIC = "empty_timeline"

var playable_character: Node2D
var camera2D: PhantomCamera2D


func _ready() -> void:
	Functions.set_dialogic_auto_advance(false)
	Dialogic.signal_event.connect(_on_dialogic_signal)
	process_mode = Node.PROCESS_MODE_PAUSABLE
	playable_character = get_node("PlayableCharacter")
	SignalBus.connect("starts_fighting", add_fight)
	SignalBus.connect("quit_game", quit_game)
	SignalBus.connect("wild_enemy_encounter", setup_battle)
	if y_sort_enabled != true:
		y_sort_enabled = true

	call_empty_dialogic_for_loading()
	set_dev_tools()
	set_map_information()

	set_character_position()
	key_variable_logic()
	map_state_logic()
	_ready_scene()

func add_to_maps_resource() -> void:
	if not Engine.is_editor_hint():
		return
	if not single_map_resource:
		push_error("No SingleMapResource assigned on this scene!")
		return
	
	if not _find_resource_in_maps_dir(single_map_resource.map_name, "res://assets/resources/maps/"):
		push_error("File does not exist on disk: " + single_map_resource.map_name + "\n" + "Make unique with same name as SingleMapResource.name and save the SingleMapResource in the 'assets/resources/maps/' directory.")
		return

	var full_maps: MapsResource = load(FULL_MAPS_RESOURCE_PATH)
	if not full_maps:
		push_error("Could not load MapsResource at: " + FULL_MAPS_RESOURCE_PATH)
		return

	if full_maps.maps.has(single_map_resource):
		print("Map already registered: ", single_map_resource.map_name)
		return

	full_maps.maps.append(single_map_resource)
	ResourceSaver.save(full_maps)
	print("Added '%s' to MapsResource" % single_map_resource.map_name)

func _ready_scene() -> void:
	pass

func add_fight() -> void:
	var battle_scene := BATTLE.instantiate()
	add_child(battle_scene)

func set_map_information() -> void:
	Globals.current_map_path = single_map_resource.scene_path

	if Globals.maps.has(single_map_resource.map_name) and Globals.overwrite_map_state == true:
		Globals.maps[single_map_resource.map_name].state = room_state	

	print("Current map set to:", single_map_resource.map_name, " with state: ", Globals.maps[single_map_resource.map_name].state, " overwrite state: ", Globals.overwrite_map_state)
		

func set_character_position() -> void:
	set_marker()
	if not Globals.from_door:
		return

	Globals.from_door = false

func set_marker() -> void:
	if Globals.target_marker == "default":
		var default_marker := get_node("SpawnsLayer/DefaultMarker")
		if default_marker:
			playable_character.position = default_marker.position
			# print("Default marker position set to:", Globals.target_marker)
		else:
			print("Default marker not found.")
			return
	elif Globals.target_marker == "":
		playable_character.position = Globals.player_position
	else:
		var target_marker := get_node("SpawnsLayer/" + Globals.target_marker)
		if target_marker == null:
			printerr("Target marker not found:", Globals.target_marker)
			target_marker = get_node("SpawnsLayer/DefaultMarker")
		
		playable_character.position = target_marker.position
		Globals.target_marker = "default"  # Reset to default after setting position
		# print("Target marker position set to:", Globals.target_marker)

func quit_game() -> void:
	print("Quitting to main menu...")
	SignalBus.emit_signal("changing_scene")
	black_rect.visible = true
	await Functions.fade_color_rect(black_rect, "IN", 2)
	print("Changing to main menu scene...")
	get_tree().change_scene_to_file("res://scenes/inicio_menu.tscn")

func setup_battle() -> void:
	audio_stream_player.set("parameters/switch_to_clip", "EnemyEncounter")
	black_rect.visible = true
	print("Setting up battle...")

	await Functions.fade_color_rect(black_rect, "IN", 0.5)
	call_deferred("start_battle")

func start_battle() -> void:
	get_tree().change_scene_to_file("res://scenes/battle/battle_map.tscn")

func _on_dialogic_signal(argument:Dictionary) -> void:
	if not argument.has("name"):
		print("Dialogic signal received without 'name' key:", argument)
		return
	var event_name :String = argument.name
	dialogic_logic(event_name)

func map_state_logic() -> void:
	pass

func dialogic_logic(event_name: String) -> void:
	pass

func key_variable_logic()-> void:
	pass

func _find_resource_in_maps_dir(map_name: String, path: String) -> bool:
	var dir := DirAccess.open(path)
	if not dir:
		return false
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		var full_path := path + file_name
		if dir.current_is_dir():
			if _find_resource_in_maps_dir(map_name, full_path + "/"):
				return true
		elif file_name.ends_with(".tres"):
			var res := load(full_path)
			if res is SingleMapResource and res.map_name == map_name:
				return true
		file_name = dir.get_next()
	dir.list_dir_end()
	return false

func set_dev_tools() -> void:
	if OS.is_debug_build() and not Globals.recording:
		var dev_ui_scene: PackedScene = preload("res://scenes/dev_ui.tscn")
		var dev_ui_instance: Node = dev_ui_scene.instantiate()
		var canvas_node :CanvasLayer= get_tree().get_current_scene().find_child("CanvasLayer")
		if canvas_node:
			print("Adding Dev UI to CanvasLayer")
			canvas_node.add_child.call_deferred(dev_ui_instance)

func call_empty_dialogic_for_loading() -> void:
	Dialogic.start(EMPTY_DIALOGIC)

func export_map_image() -> void:
	if not Engine.is_editor_hint():
		return
	var polygons:=get_all_polygon2d(self)
	var labels:=get_all_labels(self)
	var datetime := Time.get_datetime_string_from_system().replace(":", "-").replace("T", "_")
	var map_name := "res://assets/map_image_exports/%s_%s.svg" % [single_map_resource.map_name, datetime]
	save_polygons_to_svg(polygons, labels, map_name)

func get_all_polygon2d(node: Node) -> Array:
	var result := []
	for child in node.get_children(true):
		if child is Polygon2D:
			result.append(child)
		result.append_array(get_all_polygon2d(child))
	return result

func save_polygons_to_svg(polygons: Array, labels:Array , path: String) -> void:
    # Calculate bounding box
	var min_pos := Vector2(INF, INF)
	var max_pos := Vector2(-INF, -INF)
	for polygon:Polygon2D in polygons:
		for point in polygon.polygon:
			var global_point := polygon.to_global(point)
			min_pos.x = min(min_pos.x, global_point.x)
			min_pos.y = min(min_pos.y, global_point.y)
			max_pos.x = max(max_pos.x, global_point.x)
			max_pos.y = max(max_pos.y, global_point.y)

	var width := max_pos.x - min_pos.x
	var height := max_pos.y - min_pos.y

	var svg := '<svg xmlns="http://www.w3.org/2000/svg" viewBox="{x} {y} {w} {h}">\n'.format({
		"x": min_pos.x, "y": min_pos.y, "w": width, "h": height
	})

	for polygon:Polygon2D in polygons:
		var points_str := ""
		for point in polygon.polygon:
			var global_point := polygon.to_global(point)
			points_str += "%s,%s " % [global_point.x, global_point.y]

		var color :String= polygon.color.to_html(false)
		svg += '  <polygon points="%s" fill="#%s" stroke="none"/>\n' % [points_str.strip_edges(), color]
	
	for label:Label in labels:
		var global_pos := label.global_position
		var font_size := label.get_theme_font_size("font_size") 
		var color := label.get_theme_color("font_color").to_html(false)
		svg += '  <text x="%s" y="%s" font-size="%s" fill="#%s">%s</text>\n' % [
			global_pos.x, global_pos.y, font_size, color, label.text
		]

	svg += "</svg>"

	var file := FileAccess.open(path, FileAccess.WRITE)
	file.store_string(svg)
	file.close()

func get_all_labels(node: Node) -> Array:
	var result := []
	for child in node.get_children(true):
		if child is CanvasLayer:
			continue
		if child is Label:
			result.append(child)
		result.append_array(get_all_labels(child))
	return result