class_name HoveringEffect
extends Node

@export var radius: float = 20.0        # Max pixels from start position
@export var duration_min: float = 1.2   # Min seconds per movement
@export var duration_max: float = 2.2   # Max seconds per movement

var _start_position: Vector2
var _tween: Tween
var _parent: Control

func _ready() -> void:
    _parent = get_parent() as Control
    assert(_parent != null, "HoveringEffect must be a child of a Control node")
    _start_position = _parent.position
    _next_hover()

func _next_hover() -> void:
    var target := _start_position + _random_offset()
    var duration := randf_range(duration_min, duration_max)

    _tween = create_tween()
    _tween.tween_property(_parent, "position", target, duration) \
        .set_trans(Tween.TRANS_SINE) \
        .set_ease(Tween.EASE_IN_OUT)
    _tween.tween_callback(_next_hover)  # Loop automatically

func _random_offset() -> Vector2:
    # Picks a random point inside a circle for natural movement
    var angle := randf() * TAU
    var dist := randf() * radius
    return Vector2(cos(angle) * dist, sin(angle) * dist)
