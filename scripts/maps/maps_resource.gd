class_name MapsResource
extends Resource

@export var maps: Array[SingleMapResource]

func get_maps_dictionary() -> Dictionary:
	var map_dict: Dictionary = {}
	for map in maps:
		map_dict[map.name] = {
			"scene_path": map.scene_path,
			"state": map.state
		}
	return map_dict
