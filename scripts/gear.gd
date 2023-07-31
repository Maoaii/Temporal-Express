extends StaticBody2D

@export var health: Health
@export var deterioration: Deterioration

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	sprite.play("Spinning")

func _on_deterioration_component_timeout() -> void:
	health.take_damage(1)


func _on_interactable_area_body_entered(body):
	if body.name == "Player":
		var player: Player = body
		
		if player.has_oil:
			player.used_oil()
			health.full_heal()
			
		if deterioration:
			deterioration.start()


func _on_interactable_area_body_exited(body):
	pass # Replace with function body.
