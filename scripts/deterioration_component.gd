class_name Deterioration
extends Timer

@export var time_to_tick: float

func _ready():
	wait_time = time_to_tick
	
	start()

func _process(_delta: float) -> void:
	await ready
	wait_time = time_to_tick
