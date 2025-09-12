class_name Orbit extends Node2D
## The base class for orbits around stars. Uses equations from geometry to accurately put the Sun
## or other stars based on its eccentricity.

var orbit_name: String = "Earth"
var semi_major_axis: float = 1.0
var semi_minor_axis:float = 1.0
var eccentricity: float = 0.017
var rotation_rate: float = 450
var offset = 300
var color:Color = "#4391b7"
var fade = false

var star:Star
var parent_sim:Simulation

var begin_sma: float = 0

## Draws the orbit.
func _draw() -> void:
	begin_sma = semi_major_axis
	
	var a = semi_major_axis * Constants.AUPX_SCALED
	var b = (sqrt(1.0 - (eccentricity ** 2.0)) * semi_major_axis) * Constants.AUPX_SCALED
	
	var focus = sqrt((a ** 2) - (b ** 2))
	
	draw_circle(Vector2(focus, 0), Constants.AUPX_SCALED * semi_major_axis, color, false, -1)
	HelperFunctions.logprint("Drew {0}'s orbit".format([orbit_name]))

## Sets the orbit's eccentricity.
func _ready() -> void:
	# semi-minor axis multiplier
	var semi_mi_ax_scl:float = sqrt(1.0 - (eccentricity ** 2.0))
	name = orbit_name
	set_process(false)
	semi_minor_axis = semi_mi_ax_scl
	scale = Vector2(1, semi_mi_ax_scl)

var speed_mult:float = 1.0

func _process(delta: float) -> void:
	
	# Stops orbital precession, just like Algol/MrPlasma
	if star.get_stage()[0] > Star.SUBGIANT_HERTZSPRUNG:
		speed_mult = 0
	
	var rr = rotation_rate * 10
	rotate(deg_to_rad(-rr * delta) * speed_mult * parent_sim.sim_speed)
	
	if star.get_radius_au() >= get_periastron_au():
		HelperFunctions.logprint("{0} got destroyed :(".format([name]))
		visible = false
		queue_free()
		
	if (get_periastron_au() - star.get_radius_au()) <= star.get_radius_au() * 0.05:
		fade = true
	
	if fade:
		modulate = Constants.FADE

## Gets the closest point from the star. -astron relates to stars, not the Sun, where it would be called
## perihelion.
func get_periastron_au():
	return ((semi_major_axis * scale.x) * (1 - eccentricity))

func get_periastron_km():
	return ((semi_major_axis * scale.x) * (1 - eccentricity)) * Constants.AU

func set_speed_multiplier(value):
	speed_mult = value

## Gets the closest point from the star in AU
func get_apoastron_au():
	return ((semi_major_axis * scale.x) * (1 + eccentricity))

## Ditto, but in km
func get_apoastron_km():
	return ((semi_major_axis * scale.x) * (1 + eccentricity)) * Constants.AU
	
func get_semi_major_axis_au():
	return semi_major_axis * scale.x

func get_semi_major_axis_km():
	return (semi_major_axis * scale.x) * Constants.AU
