class_name Car extends CharacterBody2D


var has_bao: bool = true

var bao_amount: int = 3:
	set(value):
		bao_amount = value
		Data.bao_amount = value

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var direction: float

@export var tank_controls: bool = false

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var pickup_compass: Sprite2D = $PickupCompass
@onready var dropoff_compass: Sprite2D = $DropoffCompass

var closest_pickup_point: Marker2D
var old_dropoff: Marker2D
var current_dropoff: Marker2D

signal pause_menu

# Tank Controls
#@export var wheel_base: float = 70
@export var steering_tank_angle: float = 15

# Car controls
@export var wheel_base: float = 70
@export var steering_angle: float = 15
@export var engine_power: int = 150
@export var friction: float = -55
@export var drag: float = -0.06
@export var braking: int = -450
@export var max_speed_reverse: int = 250
@export var slip_speed: int = 600
@export var traction_fast: float = 2.5
@export var traction_slow: float = 10

var steer_direction: float
var acceleration: Vector2 = Vector2.ZERO
var throttle: float

var anim_heading: Vector2 = Vector2.ZERO

func _ready() -> void:
	bao_amount = 3

func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	
	
	
	
	point_pickup_compass()
	point_dropoff_compass()
	
	if tank_controls:
		get_tank_input()
		tank_control(delta)
		set_tank_animation()
	else:
		acceleration = Vector2.ZERO
		get_input()
		calculate_steering(delta)
		velocity += acceleration * delta
		apply_friction(delta)
		set_animation()
	
	
	#
	#print(global_position, velocity)
	
	#if steer_direction:
			#calculate_steering(delta)
	
	move_and_slide()

func tank_control(delta: float) -> void:
	if throttle:
		rotation += steer_direction * steering_tank_angle * delta
		velocity = throttle * SPEED * transform.x	
		$Sprite2D.rotation = -rotation	
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

func get_input() -> void:
	
	var turn = Input.get_axis("steer_left","steer_right")
	steer_direction = turn * deg_to_rad(steering_angle)
	
	if Input.is_action_pressed("throttle_forward"):
		acceleration = transform.x * engine_power
		
	if Input.is_action_pressed("brake") or Input.is_action_pressed("throttle_backwards"):
		acceleration = transform.x * braking
		
	
	
	#print("Steering direction: ",steer_direction, " Throttle: ",throttle)
	
func get_tank_input() -> void:
	steer_direction = Input.get_axis("steer_left", "steer_right") * deg_to_rad(steering_angle)
	
	throttle = Input.get_axis("throttle_backwards", "throttle_forward")
	
func apply_friction(delta: float) -> void:
	
	# If there is no input and speed is very low, just stop to prevent endless sliding
	if acceleration == Vector2.ZERO and velocity.length() < 50:
		velocity = Vector2.ZERO
	# Calculate friction force and air drag based on current velocity, and apply it
	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * drag * delta
	# Add the forces to the acceleration
	acceleration += drag_force + friction_force

func calculate_steering(delta: float) -> void:
	# Calculate the positions of the rear and front wheel
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	# Advance the wheels' positions based on the current velocity, applying rotation to the front wheel
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	# Calculate the new heading based on the wheels' positions
	var new_heading = rear_wheel.direction_to(front_wheel)

	# Choose the traction model based on the current speed
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast

	# Dot product represents how aligned the new heading is with the current velocity direction
	var d = new_heading.dot(velocity.normalized())

	# If not braking (d > 0), adjust the car velocity smoothly towards the new heading
	if d > 0:
		velocity = lerp(velocity, new_heading * velocity.length(), traction * delta)

	# If braking (d < 0), reverse the direction and limit the speed
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)

	# Update the car's rotation to face in the direction of the new heading
	rotation = new_heading.angle()
	$Sprite2D.rotation = -rotation
	anim_heading = new_heading

func set_animation() -> void:
	if velocity:
		var anim_direction = anim_heading.normalized()
		#if Input.is_action_pressed("throttle_backwards"):
			#anim_direction = -(anim_direction)
		animation_tree.set("parameters/Driving/blend_position", anim_direction)
		#print(velocity.normalized())

func set_tank_animation() -> void:
	if velocity:
		var anim_direction = velocity.normalized()
		if Input.is_action_pressed("throttle_backwards"):
			anim_direction = -(anim_direction)
		animation_tree.set("parameters/Driving/blend_position", anim_direction)
		#print(velocity.normalized())


#func _unhandled_input(event: InputEvent) -> void:
	#
	#if event.is_action_pressed("exit"):
		#if not Global.pause_open and not Global.main_menu_open:
			#pause_menu.emit()
			


func point_pickup_compass() -> void:
	if closest_pickup_point:
		pickup_compass.look_at(closest_pickup_point.global_position)
		pickup_compass.rotation_degrees += 45

func point_dropoff_compass() -> void:
	if current_dropoff:
		dropoff_compass.show()
		dropoff_compass.look_at(current_dropoff.global_position)
		dropoff_compass.rotation_degrees += 45
	else:
		dropoff_compass.hide()
