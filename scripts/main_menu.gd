extends Node2D

@onready var vcontainer = $MenuLayer/ColorRect/ScrollContainer/VBoxContainer
var savefiles: Array = []
var csv:Array = []

##Emits a signal containing the data, the star's original mass, and its name.
signal transmit_data(data:Array, original_mass:float, original_temp:float, star_name:String)
signal toggle_orbits(enabled: bool)
var skip_ms = false

func _ready() -> void:
	$MenuLayer.offset = Vector2.ZERO
	var user_dir = DirAccess.open("user://")
	
	if !user_dir.dir_exists("input_files"):
		user_dir.make_dir("input_files")
	
	if !user_dir.dir_exists("orbits"):
		user_dir.make_dir("orbits")
	
	if !user_dir.dir_exists("star_config"):
		user_dir.make_dir("star_config")
	
	if !user_dir.dir_exists("screenshots"):
		user_dir.make_dir("screenshots")
	
	## TODO: i poop
	var csv_input := DirAccess.open("user://input_files")
	
	## cycles thru input files folder
	var idx = -1
	
	## TODO: rewrite ts
	if csv_input.get_files().size() == 0:
		return
	
	$MenuLayer/ColorRect/ScrollContainer/VBoxContainer/Label.queue_free()
	
	for file in csv_input.get_files():

		idx += 1
		var s_button: StarButton = preload("res://scenes/star_button.tscn").instantiate()
		var opened_file = FileAccess.open("user://input_files/{0}".format([file]), FileAccess.READ)
		
		var star_name:String = file.trim_suffix(".csv")
		
		if file.begins_with("Z0."):
			star_name = "[Unnamed Star]"
		s_button.index = idx
		var teff = float(opened_file.get_csv_line()[10])
		var mass = float(opened_file.get_csv_line()[3])
		
		s_button.set_stellar_text(star_name, mass, teff)
		vcontainer.add_child(s_button)
		s_button.selected.connect(_selected_file)
		savefiles.append(s_button)
		csv.append(file)

func _selected_file(index: int, star_name:String):
	HelperFunctions.logprint("Selected the file of {0}".format([star_name]))
	var file_name: String = "user://input_files/{0}".format([csv[index]])
	var data = open_file(file_name)
	transmit_data.emit(data[0], data[1], data[2], star_name)
	$MenuLayer/ColorRect/SimButton.disabled = false
	$MenuLayer/VBoxContainer/SkipMSToggle.text = "Skip Main Sequence?\n(you have to select a star again)"


func open_file(filepath:String):
	var csv_file = FileAccess.open(filepath, FileAccess.READ)
	
	var step_a = []
	var stage_a = []
	var age_a = []
	var mass_a = []
	var lum_a = []
	var rad_a = []
	var teff_a = []

	var chz_in = []
	var chz_out = []
	var ohz_in = []
	var ohz_out = []
		
	while csv_file.get_position() < csv_file.get_length():
		var csv_line = csv_file.get_csv_line()
		
		#(unused)
		var step = float(csv_line[0])
		step_a.append(step)
		
		#Stage (main sequence, subgiant, red giant, etc.)
		var stage = float(csv_line[1])
		stage_a.append(stage)
		
		#Age
		var age = float(csv_line[2])
		age_a.append(age)
		
		#Mass
		var mass = float(csv_line[3])
		mass_a.append(mass)
		
		#Luminosity
		var lum = float(csv_line[7])
		lum_a.append(lum)
		
		#Radius
		var rad = float(csv_line[8])
		rad_a.append(rad)
		
		#Effective temperature
		var teff = float(csv_line[10])
		teff_a.append(teff)
		
		# Habitable zones
		var chzi = float(csv_line[12])
		chz_in.append(chzi)
		var chzo = float(csv_line[13])
		chz_out.append(chzo)
		var ohzi = float(csv_line[11])
		ohz_in.append(ohzi)
		var ohzo = float(csv_line[14])
		ohz_out.append(ohzo)

		# more data types will be appended to the end of the array so as to avoid problems
	var datalist:Array[Array] = [step_a, stage_a, age_a, mass_a, lum_a, rad_a, teff_a, ohz_in, ohz_out, chz_in, chz_out]
	
	var orig_mass:float = mass_a[0]
	var orig_temp:float = teff_a[0]
	
	var skip_ms_idx = 0
	if skip_ms:
		# Cycles thru the stage array and finds the first value that isnt 1 (main sequence)
		var truncated_datalist:Array[Array] = []
		for idx in stage_a.size():
			if stage_a[idx] != 1:
				skip_ms_idx = idx
				skip_ms_idx -= 2
				break
		HelperFunctions.logprint("Non-MS index: {0}".format([skip_ms_idx]))
		for data_idx in datalist.size():
			truncated_datalist.append(datalist[data_idx].slice(skip_ms_idx))
		return [truncated_datalist, orig_mass, orig_temp]
	else:
		return [datalist, orig_mass, orig_temp]

func _on_sim_button_pressed() -> void:
	$Timer.start()
	$AnimationPlayer.play("MoveDown")

func _on_timer_timeout() -> void:
	queue_free()


func _on_skip_ms_toggle_toggled(toggled_on: bool) -> void:
	skip_ms = toggled_on
	var sim:Simulation = get_parent().get_node("Simulation")
	sim.skip_ms = toggled_on
	HelperFunctions.logprint("Skipped Main Sequence: {0}".format([skip_ms]))


func _on_toggle_orbits_toggled(toggled_on: bool) -> void:
	toggle_orbits.emit(toggled_on)
	HelperFunctions.logprint("Toggled orbit: {0}".format([toggled_on]))	
