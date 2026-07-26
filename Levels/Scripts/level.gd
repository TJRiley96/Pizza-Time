class_name Level extends Node2D

var car: Car

@onready var pickup_spots: Node2D = $PickupSpots
@onready var dropoff_spots: Node2D = $DropoffSpots
@onready var spawn_marker: Marker2D = $SpawnMarker
@onready var game_timer: Timer = $GameTimer

var pickup_points: Array = []
var dropoff_points: Array = []

@export var time: int = 120

signal game_over

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	car = get_tree().get_first_node_in_group("Player")
	car.global_position = spawn_marker.global_position
	print("Player Placed ", car.global_position, " for spawn point location ", spawn_marker.global_position)
	for point in pickup_spots.get_children():
		if point is Marker2D:
			pickup_points.append(point)
			
	_on_compass_check_timer_timeout()
	
	for point in dropoff_spots.get_children():
		if point is Marker2D:
			point.update()
			dropoff_points.append(point)
			
	if dropoff_points:
		find_new_dropoff()
		
	Data.time_left = time
	Global.audio_manager.switch_song_game()
	Data.points = 0
	Data.bao_amount = 3

func init_game() -> void:
	car = get_tree().get_first_node_in_group("Player")
	car.global_position = spawn_marker.global_position
	print("Player Placed ", car.global_position, " for spawn point location ", spawn_marker.global_position)
	for point in pickup_spots.get_children():
		if point is Marker2D:
			pickup_points.append(point)
			
	_on_compass_check_timer_timeout()
	
	for point in dropoff_spots.get_children():
		if point is Marker2D:
			point.update()
			dropoff_points.append(point)
			
	if dropoff_points:
		find_new_dropoff()
		
	Data.time_left = time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if not car.current_dropoff:
		find_new_dropoff()
		
	if Data.time_left > 0:
		update_timer_hud()
	else:
		Data.game_over = true
		game_over.emit()

func find_new_dropoff() -> void:
	if dropoff_points:
		car.current_dropoff = dropoff_points.pick_random()
		while(car.current_dropoff == car.old_dropoff):
			car.current_dropoff = dropoff_points.pick_random()
			#print(car.current_dropoff == car.old_dropoff)
		car.current_dropoff.is_active = true
		car.current_dropoff.update()
		#print(car.current_dropoff)

func add_timer(amount: int) -> void:
	time += amount
	Data.time_left = time

func update_timer_hud() -> void:
	Data.minutes_left = floor(time/60)
	Data.seconds_left = time % 60


func _on_compass_check_timer_timeout() -> void:
	if not car.closest_pickup_point:
		if pickup_points:
			car.closest_pickup_point = pickup_points[0]
			
	if not car.closest_pickup_point.is_active:
		for point in pickup_points:
			if point.is_active:
				car.closest_pickup_point = point
				break
				
	for point in pickup_points:
		if car.position.distance_to(point.position) < car.position.distance_to(car.closest_pickup_point.position) and point.is_active:
			car.closest_pickup_point = point


func _on_game_timer_timeout() -> void:
	Data.time_left -= 1
