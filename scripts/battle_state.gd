class_name BattleState
extends State

var ENTER:="Enter"
var DECIDING:="Deciding"
var ATTACKING:="Attacking"
var SELECTING:="Selecting"
var RESOLVING:="Resolving"
var ENDING:="Ending"

@export var black_rect : ColorRect

func _ready() -> void:
	await owner.ready

func alive_enemies(current_arrange_enemies:Dictionary) -> Array[Character]:
	var alive_enemies_arr : Array[Character]
	if current_arrange_enemies.get("joypad_1") != null and current_arrange_enemies.get("joypad_1").current_hp > 0:
		alive_enemies_arr.append(current_arrange_enemies.get("joypad_1"))
	if current_arrange_enemies.get("joypad_2") != null and current_arrange_enemies.get("joypad_2").current_hp > 0:
		alive_enemies_arr.append(current_arrange_enemies.get("joypad_2"))
	if current_arrange_enemies.get("joypad_3") != null and current_arrange_enemies.get("joypad_3").current_hp > 0:
		alive_enemies_arr.append(current_arrange_enemies.get("joypad_3"))
	if current_arrange_enemies.get("joypad_4") != null and current_arrange_enemies.get("joypad_4").current_hp > 0:
		alive_enemies_arr.append(current_arrange_enemies.get("joypad_4"))
	
	return alive_enemies_arr

func alive_allies(current_arrange_allies:Dictionary) -> Array[Character]:
	var alive_allies_arr : Array[Character]
	if current_arrange_allies.get("left") != null and current_arrange_allies.get("left").current_hp > 0:
		alive_allies_arr.append(current_arrange_allies.get("left"))
	if current_arrange_allies.get("up") != null and current_arrange_allies.get("up").current_hp > 0:
		alive_allies_arr.append(current_arrange_allies.get("up"))
	if current_arrange_allies.get("right") != null and current_arrange_allies.get("right").current_hp > 0:
		alive_allies_arr.append(current_arrange_allies.get("right"))
	if current_arrange_allies.get("down") != null and current_arrange_allies.get("down").current_hp > 0:
		alive_allies_arr.append(current_arrange_allies.get("down"))
	
	return alive_allies_arr

func alive_characters(current_arrange:Dictionary) -> Array[Character]:
	var alive_characters_arr : Array[Character]
	if current_arrange.get("left") != null and current_arrange.get("left").current_hp > 0:
		alive_characters_arr.append(current_arrange.get("left"))
	if current_arrange.get("up") != null and current_arrange.get("up").current_hp > 0:
		alive_characters_arr.append(current_arrange.get("up"))
	if current_arrange.get("right") != null and current_arrange.get("right").current_hp > 0:
		alive_characters_arr.append(current_arrange.get("right"))
	if current_arrange.get("down") != null and current_arrange.get("down").current_hp > 0:
		alive_characters_arr.append(current_arrange.get("down"))
	
	if current_arrange.get("joypad_1") != null and current_arrange.get("joypad_1").current_hp > 0:
		alive_characters_arr.append(current_arrange.get("joypad_1"))
	if current_arrange.get("joypad_2") != null and current_arrange.get("joypad_2").current_hp > 0:
		alive_characters_arr.append(current_arrange.get("joypad_2"))
	if current_arrange.get("joypad_3") != null and current_arrange.get("joypad_3").current_hp > 0:
		alive_characters_arr.append(current_arrange.get("joypad_3"))
	if current_arrange.get("joypad_4") != null and current_arrange.get("joypad_4").current_hp > 0:
		alive_characters_arr.append(current_arrange.get("joypad_4"))
	
	return alive_characters_arr

func check_status() -> void:
	if alive_enemies(Globals.current_arrange_enemies).size() <= 0 or alive_allies(Globals.current_arrange_allies).size() <= 0:
		if alive_enemies(Globals.current_arrange_enemies).size() <= 0:
			finished.emit(ENDING, {'end': 'win'})
		if alive_allies(Globals.current_arrange_allies).size() <= 0:
			finished.emit(ENDING, {'end': 'lose'})
	else:
		finished.emit(ATTACKING)
