class_name Level
extends Node2D


func _ready() -> void:
	MusicController.play_main_music()
	
	$GUI.visible = false
	$Tutorial.visible = true
	$Tutorial/player.play("Task")
	$"Tutorial/Got it".grab_focus()
	
	get_tree().paused = true

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_got_it_pressed():
	$Tutorial.visible = false
	$GUI.visible = true
	
	get_tree().paused = false
