extends Node
@warning_ignore_start("shadowed_global_identifier")
## Kepler's third law. 
func get_distance_from_period(stellar_mass:float, t:float):
	var equation: float = (t * Constants.YEARS_S) ** 2
	var GM: float = Constants.G * (stellar_mass * Constants.KG_SOLAR_MASS)
	
	# multiply to cancel GM
	equation *= GM
	
	# divide to cancel 4 pi squared
	equation /= (4 * PI ** 2)
	
	## cuberoot to get the distance in meters
	equation = cbrt(equation)
	return equation / Constants.AU_M
	
## Kepler's third law.
func get_period_from_distance(stellar_mass:float, a:float):
	var GM: float = Constants.G * (stellar_mass * Constants.KG_SOLAR_MASS)
	var sma_m:float = a * Constants.AU_M
	
	var math = ((sma_m ** 3) * (4 * PI ** 2)) / GM
	
	return sqrt(math) / Constants.YEARS_S

func round_to_decimal_place(number:float, decimal_places: int):
	var t_r = 10 ** decimal_places
	var integer = int(number)
	var decimal = get_decimal(number)
	decimal *= t_r
	decimal = round(decimal)
	decimal /= float(t_r)
	return float(integer + decimal)

func get_decimal(number:float):
	var integer = int(number)
	var decimal = number - integer
	return decimal
	
func cbrt(a) -> float:
	return a ** (1./3.)

func get_type(variable: Variant):
	return type_string(typeof(variable))

func logprint(message:Variant) -> void:
	var print = "[{0}] {1}".format([Time.get_time_string_from_system(), message])
	print(print)

func get_time_formatted():
	var date = Time.get_date_string_from_system()
	var time_dict = Time.get_time_dict_from_system()
	var f_time = "D {0} T {1}-{2}-{3}".format([date, time_dict["hour"], time_dict["minute"], time_dict["second"]])
	return f_time
