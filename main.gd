extends Node


var game_manager_scene: PackedScene = preload("res://game_manager.tscn")
var audio_manager_scene: PackedScene = preload("res://audio_manager.tscn")

@onready var world: Node2D = $World
@onready var hud_layer: CanvasLayer = $HudLayer
@onready var main_menu_layer: CanvasLayer = $MainMenuLayer
@onready var pause_layer: CanvasLayer = $PauseLayer
@onready var game_over_layer: CanvasLayer = $GameOverLayer

var player_scene: PackedScene = preload("res://Scenes/Car/car.tscn")

var prototype_level_scene: PackedScene = preload("res://Levels/Prototype/prototype_level.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Data.game_over = false
	
	get_tree().get_first_node_in_group("MainMenu").connect("play_game", start_game)


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

func start_game() -> void:
	var level: Level = prototype_level_scene.instantiate()
	var player: Car = player_scene.instantiate()
	
	world.add_child(player)
	world.add_child(level)
	
	Global.in_game = true
	hud_layer.show()
	game_over_layer.hide()
	main_menu_layer.hide()
	unpause()

func end_game() -> void:
	
	for child in world.get_children():
		child.free()
	main_menu_layer.show()
	hud_layer.hide()
	pause_layer.hide()
	game_over_layer.hide()
	get_tree().paused = true
	

func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("exit"):
		print("Pause")
		if Global.in_game and not get_tree().paused:
			pause()
		else:
			unpause()
			

func _on_pause_menu_main_menu() -> void:
	end_game()
