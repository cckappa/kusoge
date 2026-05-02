@abstract
class_name BattleContainer
extends PanelContainer

var character_resource:Character=null

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