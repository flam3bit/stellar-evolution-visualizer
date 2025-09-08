extends Node

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_pressed():
		var key = event.keycode
		match key:
			KEY_R:
				HelperFunctions.logprint("Reloading!")
				get_tree().reload_current_scene()
			KEY_ESCAPE:
				HelperFunctions.logprint("Quitting!")
				get_tree().quit()
			KEY_P:
				print_tree_pretty()
