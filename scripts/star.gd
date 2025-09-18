@icon("res://star/41191.svg")
class_name Star extends StarBase
## Base 

## Temperature in kelvins. Determines the star's color.
@export var temperature = 5778.0

## Masses in Solar masses. Determines any orbital expansion that may happen during a star's life.
@export var mass = 1.234729843247324732894789

## Radius in Solar radius. Determines the scale of the star.
@export var radius = 1.32498743294723847983274

## Luminosity in Solar radius.
@export var luminosity = 1.35645654654645654

var speed_mult = 1.0
var stage: int = 1

var age = 0
var ts = 0
var hzi = 0
var hzo = 0
var _sname: String = "Sun" 
var init_temp:float = 5800.0
var sim_data = [1, 1, [1,0]]
var str_stage = "Main Sequence"
var supernova_idx = 99999 # scuffed ass number to prevent any interaction with existing data.
var init_mass = 1
var supernova:bool = true

@onready var sim_parent:Simulation = get_parent()

func _draw() -> void:
	draw_circle(Vector2.ZERO, Constants.SUN_PX, Color.WHITE)

func _ready() -> void:
	set_process(false)
	self_modulate = StarColors.get_color_from_temp(temperature)
	scale = Vector2(radius, radius)

var speed_idx:int

func _process(delta: float) -> void:
	max_idx = sim_data[2].size() - 1
	initial_diff = sim_data[2][1] - sim_data[2][0]
	scale = Vector2(radius, radius)
	self_modulate = StarColors.get_color_from_temp(temperature)
	advance_stage()
	match_stage(stage)
	advance_age(delta)
	change_temp(delta)
	change_radius(delta)
	change_mass(delta)
	change_luminosity(delta)
	change_hz(delta)
	
	if init_temp >= 33300:
		if stage == SUBGIANT_HERTZSPRUNG:
			speed_mult = 0.2
	
	if init_temp >= 5380 and init_temp < 5930:
		if stage == SUBGIANT_HERTZSPRUNG:
			speed_mult = 0.5
		if stage > GIANT_BRANCH and stage < He_WD:
			speed_mult = 0.25
			if stage == EARLY_AGB:
				speed_mult = 0.01
			if stage == TP_AGB:
				speed_mult = 0.0005
				
				
	if stage >= He_WD:
		
		if general_idx >= speed_idx:
			speed_mult = 1
		else:
			speed_mult = 0.01

	if stage < He_WD:
		speed_idx = general_idx + 2
	
	if general_idx == supernova_idx and supernova:
		sim_parent.animate_supernova()
		HelperFunctions.logprint("Supernova!")
		supernova = false
		
	if sim_parent.pause_sim_at_age:
		var percent:float = sim_parent.config_star_age * 0.1
		
		if get_age() >= sim_parent.config_star_age - percent:
			speed_mult = move_toward(speed_mult, 0.1, 0.15 * delta)
	else:
		if post_pause:
			speed_mult = 1
			post_pause = false

var post_pause:bool = true
var general_idx = 0
var initial_diff = sim_data[2][1] - sim_data[2][0]
var frac = 1
var max_idx = sim_data[2].size() - 1

func advance_age(delta):
	var prev_age = sim_data[2][general_idx]
	var next_age = prev_age
	
	if (general_idx == max_idx - 1):
		next_age = sim_data[2][max_idx]
	else:
		next_age = sim_data[2][general_idx + 1]
	
	var diff = next_age - prev_age
	
	if diff == 0:
		general_idx += 1
		return
	# hopefully it wont tweak out or smth
	
	frac = initial_diff / diff
	
	age += (diff * delta) * frac * speed_mult

	if age >= next_age:
		age = next_age
		if age >= sim_data[2][max_idx]:
			diff = 0
		else:
			general_idx += 1

func change_temp(delta):
	var prev_temp = sim_data[6][general_idx]
	var next_temp = prev_temp
	
	if (general_idx == max_idx - 1):
		next_temp = sim_data[6][max_idx]
	else:
		next_temp = sim_data[6][general_idx + 1]

	var diff = next_temp - prev_temp
	temperature += (diff * delta) * frac * speed_mult

	if diff < 0:
		if temperature <= next_temp:
			temperature = next_temp
	else:
		if temperature >= next_temp:
			temperature = next_temp

func change_radius(delta):
	var prev_radius = sim_data[5][general_idx]
	var next_radius = prev_radius
	if (general_idx == max_idx - 1):
		next_radius = sim_data[5][max_idx]	
	else:
		next_radius = sim_data[5][general_idx + 1]		
	var diff = next_radius - prev_radius
	radius += (diff * delta) * frac * speed_mult
	
	if diff < 0:
		if radius <= next_radius:
			radius = next_radius
	else:
		if radius >= next_radius:
			radius = next_radius

func change_mass(delta):
	var prev_mass = sim_data[3][general_idx]
	var next_mass = prev_mass

	if (general_idx == max_idx - 1):
		next_mass = sim_data[3][max_idx]
	else:
		next_mass = sim_data[3][general_idx + 1]

	var diff = next_mass - prev_mass
	
	mass += (diff * delta) * frac * speed_mult
	
	if mass < next_mass:
		mass = next_mass

func change_luminosity(delta):
	var prev_lum = sim_data[4][general_idx]
	var next_lum = prev_lum
	if (general_idx == max_idx - 1):
		next_lum = sim_data[4][max_idx]
	else:
		next_lum = sim_data[4][general_idx + 1]
	var diff = next_lum - prev_lum
	luminosity += (diff * delta) * frac * speed_mult
	
	if diff < 0:
		if luminosity < next_lum:
			luminosity = next_lum
	else:
		if luminosity > next_lum:
			luminosity = next_lum
			
func change_hzi(delta):
	var prev_hzi = sim_data[7][general_idx]
	var next_hzi = prev_hzi
	
	if (general_idx == max_idx - 1):
		next_hzi = sim_data[7][max_idx]
	else:
		next_hzi = sim_data[7][general_idx + 1]
	
	var diff = next_hzi - prev_hzi
	hzi += (diff * delta) * frac * speed_mult
	
	if diff < 0:
		if hzi < next_hzi:
			hzi = next_hzi
	else:
		if hzi > next_hzi:
			hzi = next_hzi

func change_hzo(delta):
	var prev_hzo = sim_data[8][general_idx]
	var next_hzo = prev_hzo
	
	if (general_idx == max_idx - 1):
		next_hzo = sim_data[8][max_idx]
	else:
		next_hzo = sim_data[8][general_idx + 1]
	
	var diff = next_hzo - prev_hzo
	hzo += (diff * delta) * frac * speed_mult 

	if diff < 0:
		if hzo < next_hzo:
			hzo = next_hzo
	else:
		if hzo > next_hzo:
			hzo = next_hzo

## Called per frame.
func change_hz(delta):
	change_hzi(delta)
	change_hzo(delta)

func advance_stage():
	stage = sim_data[1][general_idx]
	var next_stage = sim_data[1][general_idx + 1]
	
	if (general_idx == max_idx - 1):
		next_stage = sim_data[2][max_idx]
	else:
		next_stage = sim_data[2][general_idx + 1]


func _on_simulation_transmit_star_data(data: Array, star_name: String) -> void:
	get_parent().get_node("UI/StarProperties/StarName").text = star_name
	_sname = star_name
	ts = data[0][0]
	stage = data[1][0]
	age = data[2][0]
	temperature = data[6][0]
	init_temp = data[6][0]
	luminosity = data[4][0]
	mass = data[3][0]
	radius = data[5][0]

	hzi = data[7][0]
	hzo = data[8][0]
	
	sim_data = data
	
	self_modulate = StarColors.get_color_from_temp(temperature)
	scale = Vector2(radius, radius)
	get_supernova_index(data[1])
	
	# this removes indices that have a difference of zero
	var zero_indices:Array
	var differences:Array
	for age_val_idx in sim_data[2].size():
		var length = sim_data[2].size()
		var cur:float
		var prev:float
		
		if age_val_idx > 0:
			cur = sim_data[2][age_val_idx]
			prev = sim_data[2][age_val_idx - 1]
			
			if cur - prev > 0:
				differences.append(cur - prev)
			if cur - prev <= 1e-8:
				print(cur - prev)
				zero_indices.append(age_val_idx)
	for ind_data:Array in sim_data:
		for remove_indices in zero_indices:
			ind_data.remove_at(remove_indices)
	
func get_supernova_index(stage_array:Array):
	for idx in stage_array.size():
		supernova_idx = 99999
		if stage_array[idx] == NEUTRON_STAR or stage_array[idx] == BLACK_HOLE or stage_array[idx] == NO_REMNANT:
			supernova_idx = idx
			HelperFunctions.logprint("Supernova index: {0}".format([supernova_idx]))
			break

func match_stage(value):
	if !value == MAIN_SEQUENCE:
		pass
	match value:
		MAIN_SEQUENCE:
			str_stage = "Main Sequence"
		SUBGIANT_HERTZSPRUNG:
			str_stage = "Subgiant"
		GIANT_BRANCH:
			str_stage = "Red Giant"
		CORE_HELIUM_BURNING:
			if luminosity >= 100_000:
				if temperature > 5100 and temperature < 7400:
					str_stage = "Yellow Supergiant" 
				if temperature < 5100:
					str_stage = "Red Supergiant" 
			else:
				str_stage = "Horizontal Branch"
		EARLY_AGB:
			str_stage = "Early Asymptotic Giant Branch"
		TP_AGB:
			str_stage = "Thermally Pulsating Asymptotic Giant Branch"
		HeMS_WR:
			str_stage = "Wolf-Rayet Star"
		HeHG_WR:
			str_stage = "Wolf-Rayet Star"
		HeGB_WR:
			str_stage = "Wolf-Rayet Star"
		He_WD:
			str_stage = "White Dwarf"
			if temperature < 798:
				str_stage = "Black Dwarf"
		CARBON_OXYGEN_WD:
			str_stage = "White Dwarf"
			if temperature < 798:
				str_stage = "Black Dwarf"
		OXYGEN_Ne_WD:
			str_stage = "White Dwarf"
			if temperature < 798:
				str_stage = "Black Dwarf"
		NEUTRON_STAR:
			str_stage = "Neutron Star"
		BLACK_HOLE:
			str_stage = "Black Hole"
			temperature = 0
			self_modulate = Color(0,0,0)
		NO_REMNANT:
			str_stage = "Massless Remnant"

func set_sim_speed(number:float):
	speed_mult = number

func get_temperature():
	return temperature

func get_radius():
	return radius

func get_radius_au():
	return (radius * 695700) / (Constants.AU_M / 1000)

func get_radius_km():
	return radius * 695700

func get_mass():
	return mass

func get_luminosity():
	return luminosity

func get_age():
	return age

func get_stage():
	return [stage, str_stage]

##Gets the habitable zone of a star.
func get_hz():
	return [hzi, hzo]

func get_speed_multiplier():
	return speed_mult

func star_print_pretty():
	var string = "Name: {0}\nMass: {1}x solar mass\nRadius: {2}x solar radius\nLuminosity: {3}x solar luminosity\nTeff: {4}\nEvo. Stage: {5} ({6})".format([_sname, mass, radius, luminosity, temperature, str_stage, stage])
	return string

func set_star_name(text:String):
	_sname = text

func get_star_name():
	return _sname

func _to_string() -> String:
	return star_print_pretty()

# only for debugging purposes
func _on_timer_timeout() -> void:
	pass
