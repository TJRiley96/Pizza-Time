extends Node


var game_manager: GameManager
var audio_manager: AudioManager

var in_game: bool = true
var pause_open: bool = false
var main_menu_open: bool = false

func quit_game() -> void:
	get_tree().quit()
