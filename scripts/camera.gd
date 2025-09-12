class_name OrbitCamera extends Camera2D

var zzoom:float = 0.1
var external_zoom:float = 100
#var cam_size:Vector2 = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))

func _process(delta:float):
	detect_inputs(delta)

func set_c_zoom(value):
	zzoom = value
	zoom = Vector2(zzoom, zzoom)

func detect_inputs(delta: float):
	zzoom = clampf(zzoom, 0.00007, 100)
	if Input.is_action_pressed("zoom_in"):
		zzoom += (zzoom * 2) * delta

		zoom = Vector2(zzoom,zzoom)
	if Input.is_action_pressed("zoom_out"):
		zzoom -= (zzoom * 2) * delta

		zoom = Vector2(zzoom,zzoom)
	if Input.is_action_pressed("reset_zoom"):
		zzoom = 1
		external_zoom = 100
		zoom = Vector2(zzoom,zzoom)
	return zoom.x
