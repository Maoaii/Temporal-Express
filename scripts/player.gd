class_name Player
extends CharacterBody2D

signal task_completed
signal nearest_actionable_changed

@export_group("Movement variables")
@export var MAX_SPEED: float
@export var ACCELERATION: float
@export var FRICTION: float

@export_group("Click and move variables")
@export var CLICK_AND_MOVE: bool
@export var CLICK_AND_MOVE_DEADZONE: float

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var taskbar: ProgressBar = $Taskbar
@onready var tasktimer: Timer = $TaskTimer
@onready var direction: Marker2D = $Direction
@onready var actionable_finder: Area2D = $Direction/ActionableFinder

var has_oil: bool = false
var has_hammer: bool = false
var doing_task: bool = false
var nearest_actionable


func _ready() -> void:
	taskbar.visible = false
	taskbar.max_value = tasktimer.wait_time

func _process(delta: float) -> void:
	if Global.click_to_play:
		handle_click_movement(delta)
		handle_click_interaction()
		handle_click_direction_movement()
		handle_click_sprite_animation()
	else:
		handle_movement(delta)
		handle_interaction()
		handle_direction_rotation()
		handle_sprite_animation()
	
	
	check_nearest_actionable()


func handle_click_sprite_animation() -> void:
	var direction_to_mouse: Vector2 = position.direction_to(get_global_mouse_position())
	
	if doing_task:
		sprite.play("Task")
	elif Input.is_action_pressed("move_click"):
		sprite.play("Walking")
		
		if direction_to_mouse.x > 0:
			sprite.flip_h = false
		elif direction_to_mouse.x < 0:
			sprite.flip_h = true
	else:
		sprite.play("Idle")

func handle_sprite_animation() -> void:
	var current_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	if doing_task:
		sprite.play("Task")
	elif current_dir != Vector2.ZERO:
		sprite.play("Walking")
		
		if current_dir.x > 0:
			sprite.flip_h = false
		elif current_dir.x < 0:
			sprite.flip_h = true
	else:
		sprite.play("Idle")


func handle_interaction() -> void:
	if Input.is_action_pressed("interact") and nearest_actionable:
		interact()
	elif Input.is_action_just_released("interact") or not nearest_actionable:
		cancel_interaction()

func handle_click_interaction() -> void:
	if Input.is_action_pressed("click_interact") and nearest_actionable:
		interact()
	elif Input.is_action_just_released("click_interact") or not nearest_actionable:
		cancel_interaction()



func interact() -> void:
	doing_task = true
	taskbar.visible = true
	
	if tasktimer.is_stopped():
		tasktimer.start()
	
	taskbar.value = abs(taskbar.max_value - tasktimer.time_left)


func cancel_interaction() -> void:
	doing_task = false
	taskbar.visible = false
	tasktimer.stop()
	taskbar.value = 0

func _on_task_timer_timeout():
	var interacted_object = nearest_actionable.owner
	if interacted_object.name == "Coal Supply":
		if interacted_object.working:
			var game_manager: GameManager = get_tree().get_first_node_in_group("GameManager")
			game_manager.add_coal()
			interacted_object.coal_sound()
	if interacted_object.name == "Honk":
		interacted_object.honk()
		var train = get_tree().get_first_node_in_group("Train")
		if train.get_time_till_cow() <= 10:
			train.cow_dealt_with()
	if interacted_object.name == "Pressure Valve":
		var coal_supply = get_tree().get_first_node_in_group("CoalSupply")
		coal_supply.relief_pressure()


func _physics_process(_delta: float) -> void:
	move_and_slide()


func handle_click_movement(delta: float) -> void:
	if Input.is_action_pressed("move_click") and not doing_task:
		var target = get_global_mouse_position()
		
		velocity += position.direction_to(target) * ACCELERATION * MAX_SPEED * delta
		
		if position.distance_to(target) < CLICK_AND_MOVE_DEADZONE:
			velocity = Vector2.ZERO
	elif velocity != Vector2.ZERO:
		velocity = velocity.lerp(Vector2.ZERO, FRICTION * delta)
	
	velocity = velocity.limit_length(MAX_SPEED)


func handle_movement(delta: float) -> void:
	var current_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	if current_dir != Vector2.ZERO and not doing_task:
		velocity += current_dir * ACCELERATION * MAX_SPEED * delta
	elif velocity != Vector2.ZERO:
		velocity = velocity.lerp(Vector2.ZERO, FRICTION * delta)
	
	velocity = velocity.limit_length(MAX_SPEED)


func handle_direction_rotation() -> void:
	if doing_task:
		return
	
	if Input.is_action_pressed("up"):
		direction.rotation = PI
	elif Input.is_action_pressed("right"):
		direction.rotation = -PI/2
	elif Input.is_action_pressed("down"):
		direction.rotation = 0
	elif Input.is_action_pressed("left"):
		direction.rotation = PI/2

func handle_click_direction_movement() -> void:
	var direction_to_mouse: Vector2 = position.direction_to(get_global_mouse_position())
	
	if direction_to_mouse.y < 0 and (direction_to_mouse.x - direction_to_mouse.y) > 0 and (direction_to_mouse.x - direction_to_mouse.y) < 1:
		direction.rotation = PI
	elif direction_to_mouse.y > 0 and (direction_to_mouse.x - direction_to_mouse.y) > -1 and (direction_to_mouse.x - direction_to_mouse.y) < 0:
		direction.rotation = 0
	elif direction_to_mouse.x < 0 and (direction_to_mouse.x - direction_to_mouse.y) < 0 and (direction_to_mouse.x - direction_to_mouse.y) > -1:
		direction.rotation = PI/2
	elif direction_to_mouse.x > 0 and (direction_to_mouse.x - direction_to_mouse.y) > 0 and (direction_to_mouse.x - direction_to_mouse.y) < 1:
		direction.rotation = -PI/2


func acquired_oil() -> void:
	has_oil = true

func used_oil() -> void:
	has_oil = false

func acquired_hammer() -> void:
	has_hammer = true

func used_hammer() -> void:
	has_hammer = false


func check_nearest_actionable() -> void:
	var areas: Array[Area2D] = actionable_finder.get_overlapping_areas()
	var shortest_distance: float = INF
	var next_nearest_actionable = null
	
	for area in areas:
		var distance: float = area.global_position.distance_to(global_position)
		if distance < shortest_distance and area.collision_layer == 512:
			shortest_distance = distance
			next_nearest_actionable = area
	
	if next_nearest_actionable != nearest_actionable or not is_instance_valid(next_nearest_actionable):
		nearest_actionable = next_nearest_actionable
		emit_signal("nearest_actionable_changed", nearest_actionable)
