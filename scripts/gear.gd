extends StaticBody2D

@export var health: Health
@export var deterioration: Deterioration

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _process(_delta: float) -> void:
	sprite.speed_scale = get_tree().get_first_node_in_group("GameManager").gear_turning_speed
	deterioration.time_to_tick = get_tree().get_first_node_in_group("GameManager").deterioration_speed
	
	var current_health: int = health.get_health()
	if current_health <= 0:
		sprite.stop()
	elif current_health <= health.max_health / 4:
		sprite.play("Spinning25")
	elif current_health <= health.max_health / 2:
		sprite.play("Spinning50")
	else:
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
