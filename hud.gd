extends Control


@onready var bao_label: Label = $VBoxContainer/BaoLabel
@onready var points_label: Label = $VBoxContainer/PointsLabel
@onready var time_label: Label = $TimeLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bao_label.text = "Bao: " + str(Data.bao_amount)
	points_label.text = "Points: " + str(Data.points)
	time_label.text = "%02d: %02d" % format_time_left()

func format_time_left() -> Array:
	return [floor(Data.time_left/60), Data.time_left % 60]
