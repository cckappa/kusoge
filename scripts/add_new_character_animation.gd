extends CanvasLayer

@export var quest: Quest
@export var character: Character

@onready var new_character_text: RichTextLabel = %NewCharacterText
@onready var character_name: RichTextLabel = %CharacterName
@onready var character_sprite: TextureRect = %CharacterSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var bbtext_start:String = "[center][wave amp=60 freq=3][rainbow speed=1.0 freq=1.0 sat=0.9 val=1.0]"
var bbtext_end:String = "[/rainbow][/wave][/center]"

func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	set_text()

func play_animation() -> void:
	animation_player.play("new_character_animation")

func set_text() -> void:
	character_name.text = bbtext_start + character.name + bbtext_end

func set_character_sprite() -> void:
	character_sprite.texture = character.character_portrait

func _on_dialogic_signal(argument:Dictionary) -> void:
	var dialogic_signal:String = quest.dialogic_signal
	if dialogic_signal != "" and argument.name == dialogic_signal:
		if argument.type == "finish":
			play_animation()