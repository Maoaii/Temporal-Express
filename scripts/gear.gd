extends StaticBody2D

@export var health: Health
@export var deterioration: Deterioration

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	sprite.play("Spinning")

func _on_deterioration_component_timeout() -> void:
	health.take_damage(1)


func _on_interactive_area_on_interacted(player: Player) -> void:
	if player.has_oil:
		player.used_oil()
		health.full_heal()
		
		if deterioration:
			deterioration.start()
