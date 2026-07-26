extends Marker2D

@onready var animated_sprite_2d: AnimatedSprite2D = $Sprite/AnimatedSprite2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var cool_down_timer: Timer = $CoolDownTimer

var is_active: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#animated_sprite_2d.play("default")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Car:
		if body.bao_amount !=3:
			body.bao_amount = 3
			audio_stream_player.play()
			is_active = false
			hide()
			cool_down_timer.start()


func _on_cool_down_timer_timeout() -> void:
	show()
	is_active = true
