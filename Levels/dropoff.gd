extends Marker2D

@onready var animated_sprite_2d: AnimatedSprite2D = $Sprite/AnimatedSprite2D

var is_active: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func update() -> void:
	if is_active:
		show()
	else:
		hide()


func _on_area_2d_body_entered(body: Car) -> void:
	if is_active:
		if body is Car:
			if body.bao_amount > 0:
				body.bao_amount -= 1
				body.current_dropoff = null
				is_active = false
				update()
				Data.points += 1
				Data.time_left += 10
