extends Area2D

func _ready():
	monitoring = true

func _on_body_entered(body):
	if body.name == "Player":
		$CollisionShape2D.disabled = true
		monitoring = false
		$AnimatedSprite2D.play("Spawning")
		body.acquired_oil()

func respawn_oil():
	$CollisionShape2D.disabled = true
	monitoring = false
	$"Respawn Timer".start()


func _on_respawn_timer_timeout():
	$AnimatedSprite2D.play("Spawned")
	$CollisionShape2D.disabled = false
	monitoring = true
