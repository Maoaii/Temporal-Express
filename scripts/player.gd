extends CharacterBody2D


@export_group("Movement variables")
@export var MAX_SPEED: float
@export var ACCELERATION: float
@export var FRICTION: float


func _process(delta: float) -> void:
	handle_movement(delta)


func _physics_process(_delta: float) -> void:
	move_and_slide()


func handle_movement(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	if direction != Vector2.ZERO:
		velocity += direction * ACCELERATION * MAX_SPEED * delta
	elif velocity != Vector2.ZERO:
		velocity = velocity.lerp(Vector2.ZERO, FRICTION * delta)
	
	velocity = velocity.limit_length(MAX_SPEED)
