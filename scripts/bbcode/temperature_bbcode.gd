@tool
class_name TemperatureText extends RichTextEffect

var bbcode = "temp"

func _process_custom_fx(char_fx: CharFXTransform):
	pass
	char_fx.color = StarColors.COLORS[(char_fx.relative_index % 21) * 5][1]
