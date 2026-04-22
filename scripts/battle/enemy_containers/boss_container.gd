extends EnemyBattleClass

@export var animated_sprite:AnimatedSprite2D

func _setup() -> void:
	set_info(null)

func kill_enemy() -> void:
	dead = true
	death_texture.visible = true
	enemy_texture.modulate = Color(0.107, 0.107, 0.107)
	enemy_button.focus_mode = Control.FOCUS_NONE
	animated_sprite.stop()
