extends StaticBody2D

@export var interactive_area: InteractiveArea
@export var health: Health

func _ready() -> void:
	interactive_area.connect("body_entered", handle_body_entered)


func handle_body_entered(body) -> void:
	if body.name == "Player":
		var player: Player = body
		if player.has_oil:
			health.full_heal()
			
			player.used_oil()
		


func _on_deterioration_component_timeout():
	health.take_damage(1)
