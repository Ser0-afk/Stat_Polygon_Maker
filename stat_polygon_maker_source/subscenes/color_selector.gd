extends Control


func set_color(part : String, color : Color):
	%Color.color = color
	%Name.text = part

func get_color() -> Color:
	return %Color.color

func get_part() -> String:
	return %Name.text
