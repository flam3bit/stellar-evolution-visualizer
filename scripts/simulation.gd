class_name Simulation extends Node2D

signal transmit_star_data(data:Array, star_name:String)

@export var infobox_scene: PackedScene
@export var orbit_scene: PackedScene
@export var expansion_factor:float = 6.0

var new_infobox: PlanetInfobox
var new_orbit: Orbit
var scale_mult_multiplied:float
var scale_mult_scale:float
var new_scale_mult:float
var distance = 1
var orig_mass:float = 1.0
var cur_mass:float = 1.0
var scale_mult = orig_mass / cur_mass
var sim_speed:float = 1.0
var enable_orbits = false
var config_star_age:float = 1e200
var user_dir = DirAccess.open("user://")

## Pauses the visualization at the star's configured age.
var pause_sim_at_age = true
var skip_ms = false

#used for format strings
var ynum:int = 4
var lnum:int = 4
var rnum:int = 4
var mnum:int = 4
var dnum:int = 4
var hzinum:int = 4
var hzonum:int = 4

var dd = 1
var h_ui = 1

@onready var temp_text: RichTextLabel = $UI/StarProperties/StarTemp
@onready var lum_text: RichTextLabel = $UI/StarProperties/StarLum
@onready var rad_text: RichTextLabel = $UI/StarProperties/StarRad
@onready var mass_text: RichTextLabel = $UI/StarProperties/StarMass
@onready var evo_text: RichTextLabel = $UI/StarProperties/StarStage
@onready var dist_text: RichTextLabel = $UI/StarProperties/PlanetDist
@onready var hz_bounds: RichTextLabel = $UI/StarProperties/HZBounds
@onready var supernova_layer:CanvasLayer = $SupernovaLayer
@onready var hz_view: HabitableZone = $HabitableZone
@onready var pause: Button = $Years/Control/PauseButton
@onready var camera = $Camera

@onready var orbits: Node = $Orbits
@onready var infoboxes: VFlowContainer = $Infoboxes/InfoboxContainer

@warning_ignore_start("shadowed_variable")

func _ready() -> void:
	for child in $Infoboxes/InfoboxContainer.get_children():
		child.queue_free()
	$Star.position = $StarPos.position
	hz_view.position = $StarPos.position

func _process(_delta: float) -> void:
	var teff = $Star.get_temperature()
	var lum = $Star.get_luminosity()
	var rad = $Star.get_radius()
	var mass = $Star.get_mass()
	var evo = $Star.get_stage()[1]
	var age = $Star.get_age()
	var hz = $Star.get_hz()
	set_all_text(teff, lum, rad, mass, evo)
	set_years_text(age)
	set_zoom()
	set_hz_text(hz)
	hz_view.set_hz(hz)
	hz_view.set_star_radius($Star.get_radius_au())
	scale_mult = (orig_mass / cur_mass)
	
	if $Star.stage <= StarBase.GIANT_BRANCH:
		scale_mult_multiplied = scale_mult ** expansion_factor
		scale_mult_scale = scale_mult_multiplied / scale_mult
		new_scale_mult = scale_mult * scale_mult_scale
	
	
	if $Star.stage > StarBase.GIANT_BRANCH:
		var new:float = (scale_mult * scale_mult_scale) / new_scale_mult
		new **= 0.38
		scale_mult *= scale_mult_scale * (1.0 / new)
	else:
		scale_mult **= expansion_factor
	
	if $Star.stage > StarBase.He_WD:
		$UI/StarProperties/QuitButton.visible = true
	
	if enable_orbits:
		for infobox:PlanetInfobox in infoboxes.get_children():
			infobox.set_star_mass(mass)
			infobox.set_sma(infobox.semi_major_axis * scale_mult)
			
		for orbit:Orbit in orbits.get_children(): 
			orbit.set_speed_multiplier($Star.get_speed_multiplier())
			orbit.scale = Vector2(scale_mult, scale_mult * orbit.semi_minor_axis)
	
	if $Star.get_age() >= config_star_age and pause_sim_at_age:
		set_processes(false)
		HelperFunctions.logprint("Paused, attempted to pause at {0}, current age is {1}".format([config_star_age, $Star.get_age()]))
		HelperFunctions.logprint("PRINTING STAR INFORMATION")
		print($Star)
		
		if skip_ms:
			print_orbits()
		
		pause_sim_at_age = false
		

func set_all_text(teff:float, lum:float, rad:float, mass:float, evo:String):
	set_temp_text(teff)
	set_lum_text(lum)
	set_rad_text(rad)
	set_mass_text(mass)
	set_dist_text(mass)
	set_stage_text(evo)

func set_zoom():
	var cz = "%.4f" % $Camera.zzoom
		
	$Years/Control/ScaleLabel.text = "Zoom: {0}%".format([cz])
func set_temp_text(temperature:float):
	var t_color = StarColors.get_color_from_temp(temperature)
	temp_text.text = "[color={0}]{1} K[/color]".format([t_color, int(temperature)])


func set_years_text(year:float):
	var ctnum = 4
	var curtime:float = 0.0

	
	if year < 10:
		ynum = 4
	if year > 10 and year < 100:
		ynum = 3
	if year > 100 and year < 1000:
		ynum = 2
	if year > 1000: 
		ynum = 1
	
	var rounded_year = "%.{0}f".format([ynum]) % year
	$Years/Control/YearLabel.text = "{0} Ma".format([rounded_year])
	
	if !(config_star_age == 1e200):
		curtime = year - config_star_age		
		var abse = abs(curtime)

		if abse < 10:
			ctnum = 4
		if abse > 10 and abse < 100:
			ctnum = 3
		if abse > 100 and abse < 1000:
			ctnum = 2
		if abse > 1000:
			ctnum = 1
		
		var rounded_ct = "%.{0}f".format([ctnum]) % curtime
		$Years/Control/DiffLabel.text = "Current time: {0} Ma".format([rounded_ct]) 


func set_lum_text(luminosity:float):
	if luminosity < 10:
		lnum = 4
	if luminosity > 10 and luminosity < 100:
		lnum = 3
	if luminosity > 100 and luminosity < 1000:
		lnum = 2
	if luminosity > 1000 and luminosity < 10000:
		lnum = 1
	if luminosity > 10000:
		lnum = 0
	
	var rounded_lum = "%.{0}f".format([lnum]) % luminosity
	#print(str(luminosity) + " " + rounded_lum)

	lum_text.text = "[color=yellow]{0}L☉[/color]".format([rounded_lum])


func set_rad_text(radius:float):
	var km = false
	var earth_r = false
	var au = false
	if (radius * 695700) <= 71492: # Jupiter radius
		radius *= 695700
		
		if radius >= 6378.14: # Earth radius
			radius /= 6378.14
			earth_r = true
		else:
			km = true

	elif (radius * 695700) > (Constants.AU /2):
		radius *= 695700
		radius /= Constants.AU
		au = true
	else:
		km = false

	if radius < 10:
		rnum = 4
	if radius > 10 and radius < 100:
		rnum = 3
	if radius > 100 and radius < 1000:
		rnum = 2
	if radius > 1000 and radius < 10000:
		rnum = 1
	if radius > 10000:
		rnum = 0
	var rounded_rad = "%.{0}f".format([rnum]) % radius
	
	if !km:
		if earth_r:
			rad_text.text = "[color=chartreuse]{0}R♁[/color]".format([rounded_rad])
		elif au:
			rad_text.text = "[color=chartreuse]{0}AU[/color]".format([rounded_rad])			
		else:
			rad_text.text = "[color=chartreuse]{0}R☉[/color]".format([rounded_rad])
	else:
		rad_text.text = "[color=chartreuse]{0}km[/color]".format([rounded_rad])

func set_mass_text(mass:float):
	cur_mass = mass
	if mass < 10:
		mnum = 4
	if mass > 10 and mass < 100:
		mnum = 3
	if mass > 100:
		mnum = 2
	
	var rounded_mass = "%.{0}f".format([mnum]) % mass
	mass_text.text = "[color=deepskyblue]{0}M☉[/color]".format([rounded_mass])


func set_stage_text(stage:String):
	evo_text.text = "[color=violet]{0}[/color]".format([stage])


func set_dist_text(mass:float):
	var dist = HelperFunctions.get_distance_from_period(mass, 1)
	if dist < 10:
		dnum = 4
	if dist > 10 and dist < 100:
		dnum = 3
	if dist > 100:
		dnum = 2
	$OneYearOrbit.set_orbit_scale(dist)
	var rounded_dist = "%.{0}f".format([dnum]) % dist
	
	if $Star.get_radius_au() >= dist:
		$UI/StarProperties/PlanetDist.text = "[color=crimson]{0} AU\n(inside star)[/color]".format([rounded_dist])
	else:
		$UI/StarProperties/PlanetDist.text = "[color=crimson]{0} AU[/color]".format([rounded_dist])

func set_hz_text(hz:Array):
	var hzi = hz[0]
	var hzo = hz[1]
	
	if hzi < 10:
		hzinum = 4
	if hzi > 10 and hzi < 100:
		hzinum = 3
	if hzi > 100:
		hzinum = 2
	
	if hzo < 10:
		hzonum = 4
	if hzo > 10 and hzo < 100:
		hzonum = 3
	if hzo > 100:
		hzonum = 2
	
	var f_hzi = "%.{0}f".format([hzinum]) % hzi
	var f_hzo = "%.{0}f".format([hzonum]) % hzo
	
	hz_bounds.text = "[color=mediumseagreen]{0}AU-{1}AU[/color]".format([f_hzi, f_hzo])

func _on_main_menu_transmit_data(data:Array, original_mass:float, original_temp:float, star_name:String) -> void:
	orig_mass = original_mass
	$Star.init_mass = original_mass
	$Star.init_temp = original_temp
	transmit_star_data.emit(data, star_name)
	load_star_config(star_name)
	$Star.set_star_name(star_name)
	
	if config_star_age == 1e200:
		$Years/Control/DiffLabel.visible = false
	else:
		$Years/Control/DiffLabel.visible = true
	
	if $Star.get_age() >= config_star_age:
		pause_sim_at_age = false
	HelperFunctions.logprint("Selected a new star, clearing infoboxes and orbits")	
	for infobox:PlanetInfobox in infoboxes.get_children():
		infobox.queue_free()
	for orbit:Orbit in orbits.get_children():
		orbit.queue_free()
	
	HelperFunctions.logprint("Sim pausing at: {0} Ma".format([config_star_age]))
	if enable_orbits:
		for infobox:PlanetInfobox in infoboxes.get_children():
			infobox.queue_free()
		for orbit:Orbit in orbits.get_children():
			orbit.queue_free()
		HelperFunctions.logprint("Loading new orbits")
		load_orbits(star_name)

func load_star_config(star_name:String):
	var cfg = FileAccess.open("user://star_config/{0}.txt".format([star_name]), FileAccess.READ)
	if !cfg:
		HelperFunctions.logprint("{0} has no config file".format([star_name]))
		config_star_age = 1e200

	else:
		var delimiter = ":"
		var tab = "    "
		
		while cfg.get_position() < cfg.get_length():
			var cfg_line = cfg.get_line()
			
			if cfg_line.begins_with("AGE:"):
				config_star_age = float(cfg_line.split(":")[1].strip_edges())
				
			if cfg_line.begins_with("ZOOM:"):
				$Camera.set_c_zoom(float(cfg_line.split(":")[1].strip_edges()))
			else:
				camera.set_c_zoom(0.1)

func load_orbits(star_name:String):
	var orbits = FileAccess.open("user://orbits/{0}.txt".format([star_name]), FileAccess.READ)
	if !orbits:
		HelperFunctions.logprint("{0} has no planets :(".format([star_name]))
		return
	else:
		var delimiter = ":"
		var tab = "    "
		
		var orbits_array:Array[Orbit]
		var infoboxes:Array[PlanetInfobox]
		
		while orbits.get_position() < orbits.get_length():
			var line = orbits.get_line()

			if line.begins_with("--"):
				HelperFunctions.logprint(line)
			if line.begins_with("NAME"):
				new_infobox = infobox_scene.instantiate()

				new_orbit = orbit_scene.instantiate()

				new_infobox.box_title = line.split(delimiter)[1].strip_edges()
				new_orbit.orbit_name = line.split(delimiter)[1].strip_edges()

				new_infobox.orbit = new_orbit
				
				new_infobox.star = $Star
				new_orbit.star = $Star
				new_orbit.parent_sim = self

			if line.begins_with(tab):
				var tabstrip: String = line.lstrip(tab)
				
				if tabstrip.begins_with("SemiMajorAxis"):
					var sma = float(line.split(delimiter)[1].strip_edges())
					new_infobox.semi_major_axis = sma
					new_orbit.semi_major_axis = sma
					
				if tabstrip.begins_with("Eccentricity"):
					new_orbit.eccentricity = float(line.split(delimiter)[1].strip_edges())
					
				if tabstrip.begins_with("Rotation"):
					new_orbit.rotation_rate = float(line.split(delimiter)[1].strip_edges())
					
				if tabstrip.begins_with("Color"):
					new_infobox.box_color = Color(line.split(delimiter)[1].strip_edges())
					new_orbit.color = Color(line.split(delimiter)[1].strip_edges())
					new_orbit.position = $StarPos.position
					infoboxes.append(new_infobox)
					orbits_array.append(new_orbit)
					
				if tabstrip.begins_with("Fade"):
					new_infobox.modulate = Constants.FADE
					new_orbit.modulate = Constants.FADE
		orbits_array.sort_custom(func(a:Orbit, b:Orbit): return a.get_semi_major_axis_au() < b.get_semi_major_axis_au())
		infoboxes.sort_custom(func(a:PlanetInfobox, b:PlanetInfobox): return a.orbit.get_semi_major_axis_au() < b.orbit.get_semi_major_axis_au())
		
		for idx in orbits_array.size():
			$Orbits.add_child(orbits_array[idx])
			$Infoboxes/InfoboxContainer.add_child(infoboxes[idx])

func _on_gd_starpasta_child_order_changed() -> void:
	$AnimationPlayer.play("UIMove")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("YearMove")
	await $AnimationPlayer.animation_finished
	set_processes(true)
	HelperFunctions.logprint("Starting simulation")

func set_processes(enable:bool):
	$Star.set_process(enable)
	if enable_orbits:
		for orbit in orbits.get_children():
			orbit.set_process(enable)

func animate_supernova():
	supernova_layer.visible = true
	$SupernovaPlayer.play("Supernova")
	$Explosion.play()
	await $SupernovaPlayer.animation_finished
	supernova_layer.visible = false

func _pause_play(toggled:bool):
	var paused = toggled
	if paused:
		set_processes(false)
		pause.text = "Play"
	else:
		set_processes(true)
		pause.text = "Pause"


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_pressed():
		var key = event.keycode
		match key:
			KEY_J:
				dd += 1
				if dd % 2 == 0:
					pause.visible = false
					$NonMoving/DisableControls.text = "Controls disabled!"
					$NonMoving/DisableControls.visible = true
					$NonMoving/DisableControlsTimer.start()
				else:
					pause.visible = true
					$NonMoving/DisableControls.text = "Controls enabled!"
					$NonMoving/DisableControls.visible = true
					$NonMoving/DisableControlsTimer.start()
					dd = 1
			KEY_L:
				h_ui += 1
				if h_ui % 2 == 0:
					ui_visible(false)
				else:
					ui_visible(true)
					h_ui = 1
			KEY_Z:
				print(camera.zzoom)
			KEY_O:
				print_orbits()



func print_orbits():
	if !user_dir.dir_exists("cur_orbit_files"):
		user_dir.make_dir("cur_orbit_files")
	
	var file_name = "{0} {1}.txt".format([$Star.get_star_name(), HelperFunctions.get_time_formatted()])
	
	var file = FileAccess.open("user://cur_orbit_files/{0}".format([file_name]), FileAccess.WRITE)
	
	if orbits.get_children().size() == 0:
		return
	else:
		file.store_line($Star.star_print_pretty())
		for orbit:Orbit in orbits.get_children():
			file.store_line(orbit.pretty_print())
		HelperFunctions.logprint("Saved {0}".format([file_name]))

func ui_visible(toggled:bool):
	$UI.visible = toggled
	$NonMoving.visible = toggled
	$Infoboxes.visible = toggled

func _on_disable_controls_timer_timeout() -> void:
	$NonMoving/DisableControls.visible = false

func _on_npa_animation_finished(anim_name: StringName) -> void:
	if anim_name == "TextFade":
		$NonMoving/NowPlaying.visible = false

func _on_main_menu_toggle_orbits(enabled: bool) -> void:
	enable_orbits = enabled


func _on_star_changed_stage(new_stage: String, _stage_number: int) -> void:
	HelperFunctions.logprint("New stage: {0}".format([new_stage]))

func _on_quit_button_pressed() -> void:
	get_tree().reload_current_scene()
