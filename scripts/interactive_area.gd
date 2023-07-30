class_name InteractiveArea
extends Area2D

signal on_interacted(player)

@export var clickable: bool
@export var radius: float

var player: Player
var mouse_hover: bool = false

func _ready() -> void:
	$CollisionShape2D.shape.radius = radius


func _process(_delta: float) -> void:
	if clickable:
		if Input.is_action_just_pressed("click") and player and mouse_hover:
			emit_signal("on_interacted", player)
	else:
		if player:
			emit_signal("on_interacted", player)
	


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
