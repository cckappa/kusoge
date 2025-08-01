extends Node

signal settings_discarded
signal starts_talking
signal stops_talking
signal starts_fighting
signal finishes_fighting

## OVERWORLD

signal wild_enemy_encounter

## FIGHTING

signal damaged(value_hp:float, character:Character)
signal healed(value_hp:float, character:Character)
signal crits_signal()
signal stop_crit()
signal action_selected(action:StringName)
signal attack_menu_opened()
signal attack_menu_closed(from:Character)
signal ability_button_pressed(from:Character, attack:Ability)

## QUESTS

signal quest_added(quest:QuestResource)
signal quest_goal(quest:QuestResource)

## ITEMS

signal item_added(item:Item)
signal item_removed(item:Item)

## CHARACTERS

signal character_unlocked(character:Character)