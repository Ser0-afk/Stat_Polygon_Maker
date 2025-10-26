extends Node

var config = ConfigFile.new()

const CONFIG_PATH = "user://settings.ini"

func _ready() -> void:
	if not FileAccess.file_exists(CONFIG_PATH):
		
		config.set_value("Colors", "WINDOW_BG", Color.BLACK)
		config.set_value("Colors", "WINDOW_TEXT", Color.WHITE)
		config.set_value("Colors", "BG_COLOR", Color.TRANSPARENT)
		config.set_value("Colors", "IMG_TEXT", Color.BLACK)
		config.set_value("Colors", "POLY_COLOR", Color.GHOST_WHITE)
		config.set_value("Colors", "LINES_COLOR", Color.BLACK)
		config.set_value("Colors", "STATS_COLOR", Color.LIGHT_BLUE)
		config.set_value("Colors", "STATS_LINES_COLOR", Color.NAVY_BLUE)
		
		config.set_value("Measures", "R", 250.0)
		config.set_value("Measures", "IMG_SIZE", Vector2(800, 800))
		config.set_value("Measures", "LABELS_DISTANCE", 10)
		config.set_value("Measures", "AVG_POSITION", Vector2(800 - 75, 800 - 90) )
		
		config.set_value("Others", "VALUE_SCALE", 10)
		config.set_value("Others", "STARTING_N", 6)
		config.set_value("Others", "AA", true) 
		config.set_value("Others", "OUTPUT_PATH", "output/")
		
		config.save(CONFIG_PATH)
	
	else:
		config.load(CONFIG_PATH)
		

func save_settings(section: String, key: String, value):
	config.set_value(section, key, value)
	config.save(CONFIG_PATH)

func load_settings(section :String) -> Dictionary:
	var settings := {}
	for k in config.get_section_keys(section):
		settings[k] = config.get_value(section, k)
	return settings
