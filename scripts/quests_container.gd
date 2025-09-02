extends VBoxContainer

var quest_panel_scene :PackedScene= preload("res://scenes/quest_panel.tscn")

func _ready() -> void:
	SignalBus.connect("quest_added", _on_quest_added)
	SignalBus.connect("quest_goal", _on_quest_goal)
	SignalBus.connect("quest_finished", _on_quest_finished)
	reset_quest_container()

func _on_quest_added(quest:QuestResource) -> void:
	reset_quest_container()

func _on_quest_goal(quest:QuestResource) -> void:
	reset_quest_container()

func _on_quest_finished(quest:QuestResource) -> void:
	reset_quest_container()

func reset_quest_container() -> void:
	clear_children()
	for identifier:StringName in Quests.current_quests:
		var quest : QuestResource = Quests.current_quests[identifier]
		if quest.quest_goal_index + 1 <= quest.goal_description_list.size() and quest.quest_status != QuestResource.QuestStatus.FINISHED:
			var quest_panel:= quest_panel_scene.instantiate()
			add_child(quest_panel)
			quest_panel.set_info(quest)

func clear_children() -> void:
	if get_child_count() > 0:
		for child in get_children():
			child.queue_free()
