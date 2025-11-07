extends Control

var expressions := {
	"happy": preload ("res://assets/emotion_happy.png"),
	"regular": preload ("res://assets/emotion_regular.png"),
	"sad": preload ("res://assets/emotion_sad.png"),
}

var bodies := {
	"sophia": preload ("res://assets/sophia.png"),
	"pink": preload ("res://assets/pink.png")
}


var dialogue_items: Array[Dictionary] = [
	{
		"expression": expressions["regular"],
		"text": "[wave]I've been studying arrays and dictionaries lately.[/wave]",
		"character": bodies["sophia"],
	},
	{
		"expression": expressions["regular"],
		"text": "[wave]Oh, nice. How has it been going?[/wave]",
		"character": bodies["pink"],
	},
	{
		"expression": expressions["sad"],
		"text": "[shake]Well... it's a little complicated![/shake]",
		"character": bodies["sophia"],
	},
	{
		"expression": expressions["sad"],
		"text": "[shake]Oh![/shake]",
		"character": bodies["pink"],
	},
	{
		"expression": expressions["regular"],
		"text": "[wave]It sure takes time to click at first.[/wave]",
		"character": bodies["pink"],
	},
	{
		"expression": expressions["happy"],
		"text": "[wave]If you keep at it, eventually, you'll get the hang of it![/wave]",
		"character": bodies["pink"],
	},
	{
		"expression": expressions["regular"],
		"text": "[rainbow val=0.8]Mhhh... I see. I'll keep at it, then.[/rainbow]",
		"character": bodies["sophia"],
	},
	{
		"expression": expressions["happy"],
		"text": "[shake]Thanks for the encouragement. Time to LEARN!!![/shake]",
		"character": bodies["sophia"],
	},
]
var current_item_index := 0


@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var next_button: Button = %NextButton
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var body: TextureRect = %Body
@onready var expression: TextureRect = %Expression


func _ready() -> void:
	show_text()
	next_button.pressed.connect(advance)


func show_text() -> void:
	
	var current_item := dialogue_items[current_item_index]
	rich_text_label.text = current_item["text"]
	expression.texture = current_item["expression"]
	body.texture = current_item["character"]


	rich_text_label.visible_ratio = 0.0
	var tween := create_tween()
	var text_appearing_duration: float = current_item["text"].length() / 30.0
	tween.tween_property(rich_text_label, "visible_ratio", 1.0, text_appearing_duration)

	
	var sound_max_offset := audio_stream_player.stream.get_length() - text_appearing_duration
	var sound_start_position := randf() * sound_max_offset
	audio_stream_player.play(sound_start_position)
	tween.finished.connect(audio_stream_player.stop)

	
	slide_in()
	next_button.disabled = true
	tween.finished.connect(func() -> void:
		next_button.disabled = false
	)

func advance() -> void:
	current_item_index += 1
	if current_item_index == dialogue_items.size():
		get_tree().quit()
	else:
		show_text()



func slide_in() -> void:
	var slide_tween := create_tween()
	slide_tween.set_ease(Tween.EASE_OUT)
	body.position.x = 200
	slide_tween.tween_property(body, "position:x", 0, 0.3)
	body.modulate.a = 0
	slide_tween.parallel().tween_property(body, "modulate:a", 1, 0.2)
