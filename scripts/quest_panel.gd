extends PanelContainer

@onready var selected_button := %SelectedButton
@onready var quest_title := %QuestTitle
@onready var quest_description := %QuestDescription
@onready var quest_goal := %QuestGoal
@onready var quest_giver_texture := %QuestGiverTexture

func set_info(quest:QuestResource) -> void:
	quest_title.text = quest.name
	quest_description.text = quest.description_list[quest.quest_goal_index]
	quest_goal.text = quest.goal_description_list[quest.quest_goal_index]
	quest_giver_texture.texture = quest.quest_giver.character_portrait

func focus() -> void:
	selected_button.grab_focus()
