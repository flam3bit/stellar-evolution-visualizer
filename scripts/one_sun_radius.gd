extends Node2D

func _draw() -> void:
	draw_circle(Vector2.ZERO, Constants.SUN_PX, Color.YELLOW, false)

func _ready() -> void:
	position = get_parent().get_parent().get_node("StarPos").position
