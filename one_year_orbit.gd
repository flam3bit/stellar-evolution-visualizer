extends Node2D

# Sun's radius in pixels: 69.5700
var orb_scale = 1
var ogscale = 1
func _draw() -> void:
	draw_circle(Vector2.ZERO, Constants.AUPX_SCALED, Color.CRIMSON, false, -1)


func _process(delta: float) -> void:
	scale = Vector2(orb_scale, orb_scale)

func set_orbit_scale(value:float):
	orb_scale = value
