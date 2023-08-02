class_name CoalSupply
extends StaticBody2D

@onready var overheat_label: Label = $OverheatLabel
@onready var coal_label: Label = $CoalLabel
@onready var overheat_timer: Timer = $OverheatTimer
@onready var kaboom_timer: Timer = $KaboomTimer

@export var max_heat: int = 10

var overheat: int = 0
var working: bool = true

func _process(_delta: float) -> void:
	"""
	if working:
		$X.visible = false
	else:
		$X.visible = true
	"""
	
	coal_label.text = "Coal: " + str(get_tree().get_first_node_in_group("GameManager").coal_amount)
	overheat_label.text = "Overheat: " + str(overheat)
	
	var coal_amount = get_tree().get_first_node_in_group("GameManager").coal_amount
	match coal_amount:
		3:
			overheat_timer.wait_time = 4
		4:
			overheat_timer.wait_time = 3
		5:
			overheat_timer.wait_time = 2
	
	if overheat >= max_heat:
		if kaboom_timer.is_stopped():
			kaboom_timer.start()
		else:
			$Sprite2D.modulate = Color(abs(kaboom_timer.wait_time - kaboom_timer.time_left + 1), 0, 0)
	else:
		kaboom_timer.stop()
		$Sprite2D.modulate = Color.WHITE


func relief_pressure(amount: int = 2):
	overheat = max(overheat - amount, 0)
	$"Presure Relief Sound".play()

func coal_sound() -> void:
	$"Add Coal Sound".play()


func _on_overheat_timer_timeout():
	var coal_amount = get_tree().get_first_node_in_group("GameManager").coal_amount
	match coal_amount:
		3:
			overheat = max(overheat + 1, 10)
		4:
			overheat = max(overheat + 2, 10)
		5:
			overheat = max(overheat + 3, 10)
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
