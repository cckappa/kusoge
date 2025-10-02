extends VBoxContainer

func _ready()->void:
	%Party.text = tr("pause_menu/party")
	%ItemsButton.text = tr("pause_menu/items_button")
	%Quests.text = tr("pause_menu/quests")
	%Resume.text = tr("pause_menu/resume")
	%Quit.text = tr("pause_menu/exit")