class_name CharacterQuest
extends QuestResource

func start_quest() -> void:
	if quest_status == QuestStatus.AVAILABLE:
		quest_status = QuestStatus.STARTED
		print("Quest started")
	else:
		print("Quest already started")

func reached_goal() -> void:
	if quest_status == QuestStatus.STARTED:
		quest_status = QuestStatus.REACHED_GOAL
		print("Quest reached goal")
	else:
		print("Quest not started")

func finish_quest() -> void:
	if quest_status == QuestStatus.REACHED_GOAL:
		quest_status = QuestStatus.FINISHED
		print("Quest finished")
		add_reward()
	else:
		print("Quest not reached goal")

func add_reward() -> void:
	pass
