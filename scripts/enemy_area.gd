extends Area2D

## TODO: Hacer enemies group en lugar de enemies y metes arrays para que escoja
@export var enemies:Array[Character]
@export_enum("RANDOM", "UNIQUE") var encounter_type:="UNIQUE"
@export var check_interval := 0.5  # Time in seconds between checks
@onready var timer := $Timer


var player_inside:bool
var last_position:Vector2
var player:PlayableCharacter
var can_check := true  # Prevents checking too often
var enter_battle := false

func _ready() -> void:
	timer.wait_time = check_interval
	timer.one_shot = true  # Ensures it only triggers once per activation
	timer.timeout.connect(_reset_check)  # Calls function when done
	
	SignalBus.connect("wild_enemy_encounter", entered_battle)

func _process(delta:float) -> void:
	if player_inside and player and can_check and !enter_battle:
		var player_position :Vector2 = player.global_position
		if player_position != last_position:  # Detect movement
			last_position = player_position
			check_for_battle()
			can_check = false  # Prevent immediate rechecking
			get_node("Timer").start()  # Start the delay timer

func _on_body_entered(body:Node2D) -> void:
	if body is CharacterBody2D and body.is_in_group("main_character"):
		player = body
		player_inside = true
		last_position = player.global_position  # Store player's position

func _on_body_exited(body:Node2D) -> void:
	if body is CharacterBody2D and body.is_in_group("main_character"): 
		player_inside = false

func check_for_battle() -> void:
	var encounter_chance := 0.1  # 10% chance to trigger battle
	if randf() < encounter_chance:
		start_battle()

func start_battle()->void:
	Globals.player_position = player.position
	set_enemies()
	SignalBus.emit_signal("wild_enemy_encounter")

func set_enemies() -> void:
	var new_enemies:Array[Character]
	for enemy in enemies:
		var new_enemy := enemy.duplicate(true)
		new_enemy.set_current_hp()
		new_enemies.append(new_enemy)
	Globals.enemies = new_enemies

func _reset_check() -> void:
	can_check = true  # Re-enable battle checks after timer ends

func entered_battle() -> void:
	enter_battle = true
