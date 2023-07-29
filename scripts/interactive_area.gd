class_name InteractiveArea
extends Area2D


@export var radius: float

func _ready() -> void:
	$CollisionShape2D.shape.radius = radius

