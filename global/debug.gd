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
			KEY_S:
				
				await RenderingServer.frame_post_draw
				var viewport = get_viewport()
				get_viewport().get_texture().get_image().save_png("res://showcase/{0}.png".format([Time.get_datetime_string_from_system()]))
