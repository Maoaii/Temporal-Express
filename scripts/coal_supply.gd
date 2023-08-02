class_name CoalSupply
extends StaticBody2D

@onready var overheat_label: Label = $OverheatLabel
@onready var coal_label: Label = $CoalLabel
@onready var overheat_timer: Timer = $OverheatTimer
@onready var kaboom_timer: Timer = $KaboomTimer

@export var max_heat: int = 20
@export var pressure_relief: int = 5

var overheat: int = 0
var working: bool = true

func _process(_delta: float) -> void:
	coal_label.text = "Coal: " + str(get_tree().get_first_node_in_group("GameManager").coal_amount)
	overheat_label.text = "Overheat: " + str(overheat)
	
	if get_tree().get_first_node_in_group("Train").pressure_valve_enabled:
		if overheat >= max_heat:
			if kaboom_timer.is_stopped():
				kaboom_timer.start()
			else:
				$Sprite2D.modulate = Color(abs(kaboom_timer.wait_time - kaboom_timer.time_left + 1), 0, 0)
		elif working:
			kaboom_timer.stop()
			$Sprite2D.modulate = Color.WHITE


func relief_pressure():
	if get_tree().get_first_node_in_group("Train").pressure_valve_enabled:
		overheat = max(overheat - pressure_relief, 0)
		$"Presure Relief Sound".play()

func coal_sound() -> void:
	$"Add Coal Sound".play()


func _on_overheat_timer_timeout():
	var coal_amount = get_tree().get_first_node_in_group("GameManager").coal_amount
	match coal_amount:
		3:
			overheat = min(overheat + 2, max_heat + 5)
		4:
			overheat = min(overheat + 3, max_heat + 5)
		5:
			overheat = min(overheat + 4, max_heat + 5)
		_: overheat = max(overheat - 1, 0)


func _on_kaboom_timer_timeout():
	working = false
	
	overheat = 0
	get_tree().get_first_node_in_group("GameManager").coal_amount = 0
	$Sprite2D.modulate = Color.BLACK
	$"Explosion Sound".play()


func _on_actionable_body_entered(body):
	if body.name == "Player":
		var player: Player = body
		
		if player.has_hammer and not working:
			player.used_hammer()
			get_tree().get_first_node_in_group("Hammer").respawn_hammer()
			
			working = true
			$Sprite2D.modulate = Color.WHITE


func _on_coal_sound_finished():
	$"Coal Sound".play()


func is_overheating():
	return overheat >= max_heat

func get_overheat():
	return overheat

func get_overheat_time():
	return kaboom_timer.time_left

func enable_overheat():
	overheat_label.visible = true

func disable_overheat():
	overheat_label.visible = false
