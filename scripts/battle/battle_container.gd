@abstract
class_name BattleContainer
extends PanelContainer

var character_resource:Character=null
var viewport_size:Vector2

@abstract
func set_info(_character:Character) -> void
		
@abstract
func kill_character() -> void

@abstract
func set_health() -> void
	
@abstract
func show_damage(damage:float) -> void

@abstract
func show_attacked() -> void

func get_normalized_center() -> Vector2:
	# Convert this node's screen position to normalized 0-1 coords
	viewport_size = get_viewport_rect().size
	var screen_pos := get_global_transform_with_canvas().origin
	var normalized_center := screen_pos / viewport_size
	return normalized_center