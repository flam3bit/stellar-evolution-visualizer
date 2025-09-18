class_name PlanetInfobox extends Control
## Class for planet infoboxes. Shows name, color, the orbital period, and the semi-major axis.
@warning_ignore_start("unused_variable")
@onready var sma_lbl: Label = $VBoxContainer/BoxPanel/VBoxContainer/SemiMajorAxis
@onready var period_lbl: Label = $VBoxContainer/BoxPanel/VBoxContainer/OrbitalPeriod
@onready var boxtitle: Label = $VBoxContainer/BoxTitle

var semi_major_axis:float = 1.0
var star_mass:float = 1.0
var box_color:Color = "4391b7"
var box_title:String = "[Unnamed Planet]"
var orbit: Orbit

var cur_sma = semi_major_axis
var fade = false

@onready var star: Star

func _ready() -> void:
	if fade:
		modulate = Constants.FADE
	
	cur_sma = semi_major_axis
	boxtitle.text = box_title
	name = box_title
	$VBoxContainer/BoxTitle/ColorBG.color = box_color

func _process(_delta: float) -> void:
	update_sma(orbit.get_semi_major_axis_au())
	var period:float = HelperFunctions.get_period_from_distance(star_mass, cur_sma)
	update_period(period)
	
	if !orbit.visible:
		HelperFunctions.logprint(orbit.get_periastron_au())
		queue_free()
	
	if orbit.fade:
		fade = true
	
	if fade:
		modulate = Constants.FADE

## Mainly for formatting. 
var snum = 4

## Takes sma = semi-major axis. If under 0.1 AU convert to km.
func update_sma(sma: float):
	var km = false
	if sma < 0.1: # checks if the SMA is under 0.1 au
		sma *= Constants.AU
		km = true

	if sma < 10:
		snum = 4
	if sma > 10 and sma < 100:
		snum = 3
	if sma > 100:
		snum = 2
		
	var str_sma = "%.{0}f".format([snum]) % sma
	if !km:
		sma_lbl.text = "{0} AU".format([str_sma])
	else:
		sma_lbl.text = "{0} km".format([str_sma])		

## Mainly for formatting. 
var tnum = 4

## Takes t = period in years. Converts to days if under 1.
func update_period(t: float):
	var ot = t
	
	if t < 1:
		t *= 365
	
	if t < 10:
		tnum = 4
	if t > 10 and t < 100:
		tnum = 3
	if t > 100 and t < 1000:
		tnum = 2
	if t > 1000:
		tnum = 1
	
	if ot < 1:
		var str_t = "%.{0}f".format([tnum]) % t
		period_lbl.text = "{0} days".format([str_t])
	else:
		var str_t = "%.{0}f".format([tnum]) % t
		period_lbl.text = "{0} years".format([str_t])

func set_star_mass(value:float):
	star_mass = value

func set_sma(value:float):
	cur_sma = value
	
func set_star(star_node:Star):
	star = star_node
