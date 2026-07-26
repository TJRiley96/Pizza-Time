extends Marker2D

@onready var animated_sprite_2d: AnimatedSprite2D = $Sprite/AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#animated_sprite_2d.play("default")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body)
	if body is Car:
		body.bao_amount = 3
