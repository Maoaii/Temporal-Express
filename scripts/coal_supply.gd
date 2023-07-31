extends StaticBody2D


func _process(_delta: float) -> void:
	$Label.text = str(get_tree().get_first_node_in_group("GameManager").coal_amount)
