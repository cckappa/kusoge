extends Node

signal changing_scene
signal settings_discarded
signal starts_talking
signal stops_talking
signal starts_fighting
signal finishes_fighting
signal quit_game

## OVERWORLD

signal wild_enemy_encounter
signal play_world_animation(event_name:String)
signal start_fight(fight_identifier:StringName)

## FIGHTING

signal damaged(value_hp:float, character:Character)
signal healed(value_hp:float, character:Character)
signal crits_signal()
signal stop_crit()
signal action_selected(action:StringName)
signal attack_menu_opened()
signal item_menu_opened()
signal menu_closed(from:Character)
signal item_menu_closed(from:Character)
signal ability_cooldown_not_finished()
signal ability_name_focus_entered(ability:Ability)
signal item_name_focus_entered(item:Item)
signal ability_button_pressed(from:Character, attack:Ability)
signal item_button_pressed(from:Character, item:Item)
signal run_away()
signal loot_collected()
signal enemy_health_trigger_dialog(character:Character, dialog:EnemyFightDialog)
signal enemy_victory_dialogs_started()
signal enemy_victory_dialogs_ended()

## BATTLE MAP
signal party_character_button_pressed(character:Character)
signal attack_menu_focused(ability:Ability)
signal attack_menu_pressed(ability:Ability)
signal enemy_button_pressed(enemy:EnemyResource, control:Control, enemy_container:EnemyBattleClass)
signal enemies_defeated()
signal set_alive_allies_containers(alive_allies_containers:Array)
signal party_character_killed()


## QUESTS

signal quest_added(quest:QuestResource)
signal quest_goal(quest:QuestResource)
signal quest_finished(quest:QuestResource)

## ITEMS

signal item_added(item:Item)
signal item_removed(item:Item)

## CHARACTERS

signal character_unlocked(character:Character)

## NOTIFICATIONS

signal add_notification(title:String, body:String, image:Texture)

## MENU
signal menu_party_character_focus_entered(character:Character)
signal menu_item_focus_entered(item:Item)
signal menu_party_character_button_pressed(character:Character)
signal menu_member_character_button_pressed(character:Character)