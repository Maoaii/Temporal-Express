class_name Deterioration
extends Timer

@export var time_to_tick: float

func _ready():
	wait_time = time_to_tick
	
	start()
