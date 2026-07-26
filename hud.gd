extends Control


@onready var bao_label: Label = $VBoxContainer/BaoLabel
@onready var points_label: Label = $PointsLabel
@onready var time_label: Label = $HBoxContainer/TimeLabel

@onready var dumpling_3: TextureRect = $DumplingContainer/Dumpling3
@onready var dumpling_2: TextureRect = $DumplingContainer/Dumpling2
@onready var dumpling_1: TextureRect = $DumplingContainer/Dumpling1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bao_label.text = "Bao: " + str(Data.bao_amount)
	points_label.text = "Points: " + str(Data.points)
	time_label.text = "%02d: %02d" % format_time_left()
	set_dumplings()

func format_time_left() -> Array:
	return [floor(Data.time_left/60), Data.time_left % 60]


func set_dumplings() -> void:
	
	match Data.bao_amount:
		0:
			dumpling_3.self_modulate = Color.BLACK
			dumpling_2.self_modulate = Color.BLACK
			dumpling_1.self_modulate = Color.BLACK
			
		1:
			dumpling_3.self_modulate = Color.BLACK
			dumpling_2.self_modulate = Color.BLACK
			dumpling_1.self_modulate = Color.WHITE
			
		2:
			dumpling_3.self_modulate = Color.BLACK
			dumpling_2.self_modulate = Color.WHITE
			dumpling_1.self_modulate = Color.WHITE
			
		3:
			dumpling_3.self_modulate = Color.WHITE
			dumpling_2.self_modulate = Color.WHITE
			dumpling_1.self_modulate = Color.WHITE
