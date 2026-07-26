class_name Car extends CharacterBody2D


var has_bao: bool = true

var bao_amount: int = 3:
	set(value):
		bao_amount = value
		Data.bao_amount = value

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var wheel_base: float = 70
@export var steering_angle: float = 15

var steer_direction: float
var throttle: float

var direction: float

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var pickup_compass: Sprite2D = $PickupCompass
@onready var dropoff_compass: Sprite2D = $DropoffCompass

var closest_pickup_point: Marker2D
var old_dropoff: Marker2D
var current_dropoff: Marker2D

signal pause_menu

func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	get_input()
	point_pickup_compass()
	point_dropoff_compass()
	
	#
	#print(global_position, velocity)
	if throttle:
		rotation += steer_direction * steering_angle * delta
		velocity = throttle * SPEED * transform.x	
		$Sprite2D.rotation = -rotation	
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	#if steer_direction:
			#calculate_steering(delta)
	set_animation()
	move_and_slide()

func get_input() -> void:
	
	steer_direction = Input.get_axis("steer_left", "steer_right") * deg_to_rad(steering_angle)
	
	throttle = Input.get_axis("throttle_backwards", "throttle_forward")
	#print("Steering direction: ",steer_direction, " Throttle: ",throttle)
	
	
func calculate_steering(delta: float) -> void:
	var rear_wheels =  position - transform.x * wheel_base/2.0
	var front_wheels =  position + transform.x * wheel_base/2.0
	
	rear_wheels += velocity * delta
	front_wheels += velocity.rotated(steer_direction) * delta
	var new_direction = (front_wheels - rear_wheels).normalized()
	velocity = new_direction * velocity.length()
	rotation = new_direction.angle()

func set_animation() -> void:
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
