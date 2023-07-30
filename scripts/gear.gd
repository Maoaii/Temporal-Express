extends StaticBody2D

@export var health: Health
@export var deterioration: Deterioration

func _on_deterioration_component_timeout():
	health.take_damage(1)


func _on_interactive_area_on_interacted(player):
	if player.has_oil:
		player.used_oil()
		health.full_heal()
		
		if deterioration:
			deterioration.start()
