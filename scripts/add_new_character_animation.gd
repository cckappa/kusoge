extends Control

@export var animation_duration: float = 2.0

@onready var new_character_text: RichTextLabel = %NewCharacterText
@onready var character_name: RichTextLabel = %CharacterName
@onready var character_sprite: TextureRect = %CharacterSprite
@onready var animation_player: AnimationPlayer = %AnimationPlayer

var bbtext_start:String = "[center][wave amp=60 freq=3][rainbow speed=0.2 freq=1.0 sat=0.9 val=1.0]"
var bbtext_end:String = "[/rainbow][/wave][/center]"

func _ready() -> void:
	SignalBus.connect("character_unlocked", character_unlocked)
	new_character_text.text = tr("add_new_character_animation/new_character")

func play_animation() -> void:
	animation_player.play("new_character_animation")

func set_text(character:Character) -> void:
	character_name.text = bbtext_start + character.name + bbtext_end

func set_character_sprite(character:Character) -> void:
	character_sprite.texture = character.character_portrait

func character_unlocked(character:Character) -> void:
	set_text(character)
	set_character_sprite(character)
	play_animation()
	await animation_player.animation_finished
	await get_tree().create_timer(animation_duration).timeout
	animation_player.play("hide_new_character")