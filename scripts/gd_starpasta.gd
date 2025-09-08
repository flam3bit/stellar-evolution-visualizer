extends Node

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_pressed():
		var key = event.keycode
		match key:
			KEY_P:
				print_tree_pretty()

func _ready() -> void:
	HelperFunctions.logprint("{1} v{0}".format([ProjectSettings.get_setting("application/config/version"), ProjectSettings.get_setting("application/config/name")]))
	
	HelperFunctions.logprint("Printing system info. No, we're not Microsoft.")
	HelperFunctions.logprint("OS: {0} ({1})".format([OS.get_name(), OS.get_distribution_name()]))
