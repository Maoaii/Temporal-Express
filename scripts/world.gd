class_name Level
extends Node2D


func _ready() -> void:
	Global.set_level(get_tree().current_scene.scene_file_path)
	MusicController.play_main_music()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		get_tree().change_scene_to_file("res://scenes/world.tscn")
