extends Node

var config := ConfigFile.new()
const CONFIG_PATH = "user://settings.ini"

var colors
var measures
var others
var gui_colors

func _ready() -> void:
	if not FileAccess.file_exists(CONFIG_PATH):
		create_settings()
	else:
		config.load(CONFIG_PATH)
	
	##for version compatibility, replaces old file while keeping settings
	if config.get_value("DEBUG", "VERSION") != globals.VERSION:
		var old_config := ConfigFile.new()
		 
		##loads old config settings
		for i in config.get_sections():
			for j in config.get_section_keys(i):
				old_config.set_value(i, j, config.get_value(i, j))
				
		create_settings()
		
		##reloads setting from old config
		for i in old_config.get_sections():
			for j in old_config.get_section_keys(i):
				config.set_value(i, j, old_config.get_value(i, j))
				
	config.save(CONFIG_PATH)
	
	colors = load_settings("Colors")
	measures = load_settings("Measures")
	others =  load_settings("Others")
	gui_colors = load_settings("GUI_Colors")

##default settings
func create_settings():
	config.set_value("DEBUG", "VERSION", 2.0)
	
	config.set_value("GUI_Colors", "WINDOW_BG", Color(0.282353, 0.239216, 0.545098, 1))
	config.set_value("GUI_Colors", "WINDOW_TEXT", Color(0.878431, 1, 1, 1))
	config.set_value("GUI_Colors", "PANELS", Color(0.102722, 0.107756, 0.140625, 1))
	config.set_value("GUI_Colors", "BUTTONS", Color(0.392609, 0.420879, 0.605469, 1))
	config.set_value("GUI_Colors", "LINE_EDIT_BG", Color(0.184314, 0.206863, 0.309804, 1))
	
	config.set_value("Colors", "BG_COLOR", Color.TRANSPARENT)
	config.set_value("Colors", "IMG_TEXT", Color.BLACK)
	config.set_value("Colors", "POLY_COLOR", Color.GHOST_WHITE)
	config.set_value("Colors", "LINES_COLOR", Color.BLACK)
	config.set_value("Colors", "STATS_COLOR", Color.LIGHT_BLUE)
	config.set_value("Colors", "STATS_LINES_COLOR", Color.NAVY_BLUE)
	
	config.set_value("Measures", "R", 250)
	config.set_value("Measures", "CENTER", Vector2i(400, 400))
	config.set_value("Measures", "IMG_SIZE", Vector2i(800, 800))
	config.set_value("Measures", "LABELS_DISTANCE", 10)
	config.set_value("Measures", "AVG_POSITION", Vector2i(800 - 75, 800 - 90) )
	
	config.set_value("Others", "VALUE_SCALE", 10)
	config.set_value("Others", "STARTING_N", 6)
	config.set_value("Others", "AA", true) 
	config.set_value("Others", "OUTPUT_PATH", "output/")
	config.set_value("Others", "IMG_SCALE", 1)
	config.set_value("Others", "SCALING_ON", true)
	config.set_value("Others", "CENTER_AT_CENTER", true)
	config.set_value("Others", "AUTO_AVG", true)
	
	
##updates config file with single key
func save_settings(section: String, key: String, value):
	config.set_value(section, key, value)
	
	if key == "CENTER_AT_CENTER" and others["CENTER_AT_CENTER"]:
		var img_size = config.get_value("Measures", "IMG_SIZE")
		config.set_value("Measures", "CENTER", img_size/2)
		measures["CENTER"] = img_size/2
		
	if key == "AUTO_AVG" and others["AUTO_AVG"]:
		var position = config.get_value("Measures", "IMG_SIZE") - Vector2i(75,90)
		config.set_value("Measures", "AVG_POSITION", position)
		measures["AVG_POSITION"] = position
		
	config.save(CONFIG_PATH)

func load_settings(section :String) -> Dictionary:
	var settings := {}
	for k in config.get_section_keys(section):
		settings[k] = config.get_value(section, k)
	return settings

func reload_settings():
	measures = load_settings("Measures")
	others =  load_settings("Others")

func reload_colors():
	colors = load_settings("Colors")
	gui_colors = load_settings("GUI_Colors")
