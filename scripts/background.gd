extends ParallaxBackground

@export var background_scroll: Vector2

func _process(delta):
	scroll_base_offset -= background_scroll * delta
