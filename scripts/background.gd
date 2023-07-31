extends ParallaxBackground

@export var background_scroll: Vector2

func _process(delta):
	scroll_base_offset -= Vector2(get_tree().get_first_node_in_group("GameManager").train_speed, 0) * delta
