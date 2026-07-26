extends Node


var game_manager_scene: PackedScene = preload("res://game_manager.tscn")
var audio_manager_scene: PackedScene = preload("res://audio_manager.tscn")

@onready var hud_layer: CanvasLayer = $HudLayer
@onready var main_menu_layer: CanvasLayer = $MainMenuLayer
@onready var pause_layer: CanvasLayer = $PauseLayer
@onready var game_over_layer: CanvasLayer = $GameOverLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Data.game_over = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func load_game() -> void:
	pass


func open_main_menu() -> void:
	pass
	
func close_main_menu() -> void:
	pass

func pause() -> void:
	pause_layer.show()
	get_tree().paused = true

func unpause() -> void:
	pause_layer.hide()
	get_tree().paused = false

func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("exit"):
		print("Pause")
		if Global.in_game and not get_tree().paused:
			pause()
		else:
			unpause()
			
	
	
	
