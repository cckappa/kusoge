class_name EnemyDetection
extends Node2D

@export var angle_cone_of_vision:= 90.0
@export var max_view_distance:= 800.0
@export var angle_between_rays:= 5.0
@export var warning_sprite:Sprite2D
@export var area_fight:Area2D

var fighting:= false

func _ready() -> void:
	angle_between_rays = deg_to_rad(angle_between_rays)
	angle_cone_of_vision = deg_to_rad(angle_cone_of_vision)
	area_fight.monitoring = false
	area_fight.connect('body_entered', entered_fight_zone)
	SignalBus.connect("finishes_fighting", reset_fighting)
	generate_raycasts()

func generate_raycasts() -> void:
	var ray_count := angle_cone_of_vision / angle_between_rays
	for index in ray_count:
		var ray:= RayCast2D.new()
		var angle:= angle_between_rays * (index - ray_count / 2.0)
		ray.target_position.y = max_view_distance
		ray.rotation = angle
		add_child(ray)
		ray.enabled = true
	
func _physics_process(delta:float) -> void:
	if fighting:
		pass

	for ray in get_children():
		if ray.has_method('is_colliding') and ray.is_colliding() and ray.get_collider().is_in_group("main_character"):
			warning_sprite.visible = true
			area_fight.monitoring = true
			break
		else:
			warning_sprite.visible = false
			area_fight.monitoring = false

func entered_fight_zone(body:Node2D) -> void:
	if body.is_in_group("main_character"):
		fighting = true
		SignalBus.emit_signal("starts_fighting")

func reset_fighting() -> void:
	fighting = false
