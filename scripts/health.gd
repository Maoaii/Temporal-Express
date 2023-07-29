class_name Health
extends Node2D

signal on_health_changed(amount: int)
signal on_health_depleted

@export var enable_health_bar: bool
@export var max_health: int
@export var health_step: int
@export var show_percentage: bool

@onready var health_bar: ProgressBar = $HealthBar

func _ready() -> void:
	if enable_health_bar:
		health_bar.max_value = max_health
		health_bar.step = health_step
		health_bar.show_percentage = show_percentage
		health_bar.value = max_health

func take_damage(amount: int) -> void:
	health_bar.value -= amount
	
	emit_signal("on_health_changed", amount)
	
	if health_bar.value <= 0:
		emit_signal("on_health_depleted")


func heal(amount: int) -> void:
	health_bar.value += amount
	health_bar.value = min(health_bar.value, health_bar.max_value)
	
	emit_signal("on_health_changed", amount)

func full_heal() -> void:
	var tmp_health = health_bar.value
	health_bar.value = health_bar.max_value
	
	emit_signal("on_health_changed", health_bar.value - tmp_health)
