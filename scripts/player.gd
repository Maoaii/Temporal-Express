extends CharacterBody2D


@export_group("Movement variables")
@export var CLICK_AND_MOVE: bool
@export var MAX_SPEED: float
@export var ACCELERATION: float
@export var FRICTION: float
@export var CLICK_AND_MOVE_DEADZONE: float

var target

func _input(event):
	if event.is_action_pressed("move_click"):
		target = get_global_mouse_position()


func _process(delta: float) -> void:
	handle_movement(delta)


func _physics_process(delta: float) -> void:
	if CLICK_AND_MOVE and target:
		velocity += position.direction_to(target) * ACCELERATION * MAX_SPEED * delta
		if position.distance_to(target) < CLICK_AND_MOVE_DEADZONE:
			velocity = Vector2.ZERO
	move_and_slide()


func handle_movement(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	if direction != Vector2.ZERO:
		velocity += direction * ACCELERATION * MAX_SPEED * delta
	elif velocity != Vector2.ZERO:
		velocity = velocity.lerp(Vector2.ZERO, FRICTION * delta)
	
	velocity = velocity.limit_length(MAX_SPEED)
