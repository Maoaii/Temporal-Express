extends StaticBody2D

@onready var overheat_label: Label = $OverheatLabel
@onready var overheat_timer: Timer = $OverheatTimer
@onready var kaboom_timer: Timer = $KaboomTimer

var overheat: int = 0
var working: bool = true

func _process(_delta: float) -> void:
	if working:
		$X.visible = false
	else:
		$X.visible = true
	
	$Label.text = str(get_tree().get_first_node_in_group("GameManager").coal_amount)
	overheat_label.text = str(overheat)
	
	var coal_amount = get_tree().get_first_node_in_group("GameManager").coal_amount
	match coal_amount:
		3:
			overheat_timer.wait_time = 4
		4:
			overheat_timer.wait_time = 3
		5:
			overheat_timer.wait_time = 2
	
	if overheat > 9:
		if kaboom_timer.is_stopped():
			kaboom_timer.start()
	else:
		kaboom_timer.stop()


func relief_pressure(amount: int = 2):
	overheat = max(overheat - amount, 0)


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


func _on_actionable_body_entered(body):
	if body.name == "Player":
		var player: Player = body
		
		if player.has_hammer and not working:
			player.used_hammer()
			
			working = true
