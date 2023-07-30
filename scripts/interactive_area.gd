class_name InteractiveArea
extends Area2D

signal clicked(player)

@export var radius: float

var player: Player
var mouse_hover: bool = false

func _ready() -> void:
	$CollisionShape2D.shape.radius = radius


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click") and player and mouse_hover:
		emit_signal("clicked", player)
		print("Clicked: " + get_parent().name)


func _on_body_entered(body):
	if body.name == "Player":
		player = body


func _on_body_exited(body):
	if body.name == "Player":
		player = null


func _on_mouse_entered():
	mouse_hover = true


func _on_mouse_exited():
	mouse_hover = false
