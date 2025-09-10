class_name HabitableZone extends Node2D


var hz_bounds:Array = [1.0, 2.0]

# oh boy.
func _draw() -> void:
	var au_px = Constants.AUPX_SCALED
	var hz_dist:float = ((hz_bounds[0] + hz_bounds[1]) / 2) * au_px
	var hz_thick:float = (hz_bounds[1] - hz_bounds[0]) * au_px

	draw_circle(Vector2.ZERO, hz_dist, Color.MEDIUM_SEA_GREEN, false, hz_thick)

func _process(delta: float) -> void:
	queue_redraw()


func set_hz(values:Array):
	hz_bounds = values 
