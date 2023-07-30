class_name Player
extends CharacterBody2D


@export_group("Movement variables")
@export var MAX_SPEED: float
@export var ACCELERATION: float
@export var FRICTION: float

@export_group("Click and move variables")
@export var CLICK_AND_MOVE: bool
@export var CLICK_AND_MOVE_DEADZONE: float


var has_oil: bool = false


func _process(delta: float) -> void:
	if CLICK_AND_MOVE:
		handle_click_movement(delta)
	else:
		handle_movement(delta)


func _physics_process(_delta: float) -> void:
	move_and_slide()


func handle_click_movement(delta: float) -> void:
	if Input.is_action_pressed("move_click"):
		var target = get_global_mouse_position()
		
		velocity += position.direction_to(target) * ACCELERATION * MAX_SPEED * delta
		
		if position.distance_to(target) < CLICK_AND_MOVE_DEADZONE:
			velocity = Vector2.ZERO
	elif velocity != Vector2.ZERO:
		velocity = velocity.lerp(Vector2.ZERO, FRICTION * delta)
	
	velocity = velocity.limit_length(MAX_SPEED)


func handle_movement(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	if direction != Vector2.ZERO:
		velocity += direction * ACCELERATION * MAX_SPEED * delta
	elif velocity != Vector2.ZERO:
		velocity = velocity.lerp(Vector2.ZERO, FRICTION * delta)
	
	velocity = velocity.limit_length(MAX_SPEED)


func acquired_oil() -> void:
	has_oil = true


func used_oil() -> void:
	has_oil = false
