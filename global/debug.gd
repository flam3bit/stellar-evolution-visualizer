extends Node

signal before_restart

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_pressed():
		var key = event.keycode
		match key:
			KEY_R:
				HelperFunctions.logprint("Reloading!")
				before_restart.emit()
				get_tree().reload_current_scene()
			KEY_ESCAPE:
				HelperFunctions.logprint("Quitting!")
				get_tree().quit()
			KEY_S:
				var viewport = get_viewport()
				var filepath = "user://screenshots/{0}.png".format([HelperFunctions.get_time_formatted()])
				await RenderingServer.frame_post_draw
				viewport.use_hdr_2d = false
				viewport.get_texture().get_image().save_png(filepath)
				HelperFunctions.logprint("Saved '{0}' to user://screenshots".format([filepath]))
				await RenderingServer.frame_post_draw
				viewport.use_hdr_2d = true
