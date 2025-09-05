extends PanelContainer
@export var spawn_duration: float = 0.6
@export var bounce_height: float = 50.0

@onready var new_item_text:= %NewItemText
@onready var new_item_quantity:= %NewItemQuantity

var item_name:String = "Unknown Item"
var item_quantity:int = 1

func animate_loot_spawn(target_position: Vector2, delay: float) -> void:
	"""Animates a single loot item spawn with bounce effect"""
	# Set initial position (above target with some randomness)
	new_item_text.text = "[center][wave amp=60 freq=3]%s" % item_name
	new_item_quantity.text = "[center][wave amp=60 freq=3]X%s" % str(item_quantity)

	var start_position := target_position + Vector2(
		randf_range(-20, 20), 
		-bounce_height - randf_range(50, 100)
	)
	position = start_position
	
	# Make item initially invisible/small
	modulate.a = 0.0
	scale = Vector2.ZERO
	
	# Create tween AFTER the delay to avoid it being invalidated
	var tween := create_tween()
	tween.set_parallel(true)  # Allow multiple animations simultaneously
	
	# Add delay to all animations instead of awaiting
	var fade_tween := tween.tween_property(self, "modulate:a", 1.0, spawn_duration * 0.3)
	fade_tween.set_delay(delay)

	var scale_tween := tween.tween_property(self, "scale", Vector2.ONE, spawn_duration * 0.4)
	scale_tween.set_delay(delay)
	scale_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	# Bounce animation (drop down then bounce up slightly)
	var bounce_tween := tween.tween_property(
		self, "position", target_position, spawn_duration
	)
	bounce_tween.set_delay(delay)
	bounce_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	
	# Optional: Add a subtle rotation wobble
	var rotation_tween1 := tween.tween_property(self, "rotation", randf_range(-0.1, 0.1), spawn_duration * 0.6)
	rotation_tween1.set_delay(delay)

	var rotation_tween2 := tween.tween_property(self, "rotation", 0.0, spawn_duration * 0.4)
	rotation_tween2.set_delay(delay + spawn_duration * 0.6)
	# # Create tween
	# var tween := get_tree().create_tween()
	# tween.set_parallel(true)  # Allow multiple animations simultaneously
	
	# # Delay before starting animation
	# # await get_tree().create_timer(delay).timeout
	
	# # Fade in and scale up
	# tween.tween_property(self, "modulate:a", 1.0, spawn_duration * 0.3)
	# tween.tween_property(self, "scale", Vector2.ONE, spawn_duration * 0.4)\
	# 	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	# # # Bounce animation (drop down then bounce up slightly)
	# # var bounce_tween := tween.tween_method(
	# # 	update_bounce_position.bind(start_position, target_position),0.0, 1.0, spawn_duration
	# # )
	# # bounce_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	
	# # # Optional: Add a subtle rotation wobble
	# tween.tween_property(self, "rotation", randf_range(-0.1, 0.1), spawn_duration * 0.6)
	# tween.tween_property(self, "rotation", 0.0, spawn_duration * 0.4)

func update_bounce_position(start_pos: Vector2, target_pos: Vector2, progress: float) -> void:
	"""Updates item position during bounce animation"""
	position = start_pos.lerp(target_pos, progress)
