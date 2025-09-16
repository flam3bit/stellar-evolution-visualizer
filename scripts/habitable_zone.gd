class_name HabitableZone extends Node2D


var hz_bounds:Array = [1.0, 2.0]

## value in AU
var star_radius:float

# oh boy.
func _draw() -> void:
	var au_px = Constants.AUPX_SCALED
	var hz_dist:float = ((hz_bounds[0] + hz_bounds[1]) / 2.0) * au_px
	var hz_thick:float = (hz_bounds[1] - hz_bounds[0]) * au_px

	# op. HZ taken from the data
	draw_circle(Vector2.ZERO, hz_dist, Color.MEDIUM_SEA_GREEN, false, hz_thick)
	# Starts at 120% the star's radius and ends at the lower bound
	var hot_bound = star_radius * 25
	var hot_dist = ((hz_bounds[0] + hot_bound) / 2.0) * au_px
	var hot_thick = (hz_bounds[0] - hot_bound) * au_px
	
	# hot zone from inside the star
	draw_circle(Vector2.ZERO, hot_dist, Color.FIREBRICK, false, hot_thick)
	
	var cold_bound = hz_bounds[1] * 2.0
	var cold_dist = ((hz_bounds[1] + cold_bound) / 2.0) * au_px
	var cold_thick = (cold_bound - hz_bounds[1]) * au_px
	
	draw_circle(Vector2.ZERO, cold_dist, Color.DARK_BLUE, false, cold_thick)
	
	# too hot zone
	
func _process(_delta: float) -> void:
	queue_redraw()


func set_hz(values:Array):
	hz_bounds = values 

func set_star_radius(value:float):
	star_radius = value
