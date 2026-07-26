extends Control

signal main_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func open_pause() -> void:
	show()
	


func _on_quit_button_pressed() -> void:
	Global.quit_game()


func _on_main_menu_button_pressed() -> void:
	main_menu.emit()
