extends Node

const SAVE_PATH = "res://particles/Settings/settings.cfg"

var _config_file = ConfigFile.new()
var _settings = {
	"display": {
		"fullscreen": "false"
	},
	"audio": {
		"music": "true",
		"sound": "true"
	}
}

var start_game = false

func _ready():
	save_settings()
	load_settings()
	start_game = true
	
func save_settings():
	#run if there is not cfg file or game has started
	if start_game == true or _config_file.load(SAVE_PATH) != OK:
		#print("run")
		for section in _settings.keys():
			for key in _settings[section].keys():
				_config_file.set_value(section, key, get_bool_value(_settings[section][key]))
				
		_config_file.save(SAVE_PATH)
	pass
	
func load_settings():
	var values = []
	
	var result = _config_file.load(SAVE_PATH)
	if result != OK:
		print("Error loading settings. Error code %s" % result)
		return values
	elif start_game == false: #first load
		for section in _settings.keys():
			for key in _settings[section].keys():
				_settings[section][key] = _config_file.get_value(section, key)
		pass
	
	for section in _config_file.get_sections():
		for key in _config_file.get_section_keys(section):
			var value = _config_file.get_value(section, key)
			#Printing the values for debug purposes
			#print("%s: %s %s" % [key, value, get_bool_value(value)])
			#generate settings
			if key == "fullscreen":
				OS.window_fullscreen = get_bool_value(value)
			if key == "music":
				AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), !get_bool_value(value))
			if key == "sound":
				AudioServer.set_bus_mute(AudioServer.get_bus_index("Sound"), !get_bool_value(value))
	return values
	
func get_setting(category, key):
	var value = _settings[category][key]
	var bool_value = get_bool_value(value)
	return bool_value

func set_setting(category, key, value):
	_settings[category][key] = value
	
func get_bool_value(val):
	var bool_val

	if typeof(val) != 1:
		if val == "true" or val == "True":
			bool_val = true
		if val == "false" or val == "False":
			bool_val = false
		return bool_val
	else: 
		return val
	
	