class_name AudioManager extends Node

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var in_menu: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.audio_manager = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func play_music() -> void:
	audio_stream_player.play(0)
	print("Music Playing")

func stop_music() -> void:
	audio_stream_player.stop()

func switch_song() -> void:
	if in_menu:
		audio_stream_player.stream = load("res://Assets/Audio/Saving the City 16-bit - Loop.wav")
		audio_stream_player.play()
		in_menu = false
	else:
		audio_stream_player.stream = load("res://Assets/Audio/JDB_Isolation.wav")
		audio_stream_player.play()
		in_menu = true
