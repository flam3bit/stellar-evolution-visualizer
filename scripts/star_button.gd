class_name StarButton extends Button

var index = -1
var s_name = "[Unnamed Star]"

## index: list position, mass: solar masses, z: metallicity
signal selected(index: int, star_name:String)

func set_stellar_text(star_name:String, mass:float, temperature:float):
	s_name = star_name
	text = "{0}\nMass: {1}M☉\nTemperature: {2} K".format([star_name, HelperFunctions.round_to_decimal_place(mass,1), int(temperature)])
	$AspectRatioContainer/StarIcn.self_modulate = StarColors.get_color_from_temp(temperature)

func _on_pressed() -> void:
	selected.emit(index, s_name)
