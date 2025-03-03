extends BattleState

const ATTACK_LETTER = preload("res://scenes/attack_letter.tscn")
var events_arr:Array[StringName]
var letter_timer:Timer
var timer_start_time:=2
var timer_reset_time:= 1
var active_attacker:Character

func enter(previous_state_path: String, data := {}) -> void:
	active_attacker = data.character
	letter_timer = Timer.new()
	add_child(letter_timer)
	letter_timer.one_shot = true
	letter_timer.start(timer_start_time)
	letter_timer.connect("timeout", check_sequence)

func handle_input(event:InputEvent) -> void:
	if event.is_action_pressed("dash"):
		events_arr.append("dash")
		reset_timer(timer_reset_time)
		add_letter("DASH")
	elif event.is_action_pressed("talks"):
		events_arr.append("talks")
		reset_timer(timer_reset_time)
		add_letter("X")
	elif event.is_action_pressed("move_down"):
		events_arr.append("down")
		reset_timer(timer_reset_time)
		add_letter("DOWN")
	elif event.is_action_pressed("move_up"):
		events_arr.append("up")
		reset_timer(timer_reset_time)
		add_letter("UP")
	elif event.is_action_pressed("move_left"):
		events_arr.append("left")
		reset_timer(timer_reset_time)
		add_letter("LEFT")
	elif event.is_action_pressed("move_right"):
		events_arr.append("right")
		reset_timer(timer_reset_time)
		add_letter("RIGHT")
	else:
		pass

func add_letter(letter_text:StringName) -> void:
	var attack_letter := ATTACK_LETTER.instantiate()
	attack_letter.text = "[center]"+letter_text
	add_child(attack_letter)

func reset_timer(time_sec:float) -> void:
	letter_timer.stop()
	letter_timer.start(time_sec)

func check_sequence() -> void:
	print(events_arr)
	for ability in active_attacker.abilities:
		if events_arr == ability.sequence:
			finished.emit(TARGETING, {"ability":ability})
