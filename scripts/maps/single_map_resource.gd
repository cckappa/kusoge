@tool
class_name SingleMapResource
extends Resource


@export var scene_path: String
@export var state: String = "default"

var map_name: String:
	get:
		return scene_path.get_file().get_basename()
