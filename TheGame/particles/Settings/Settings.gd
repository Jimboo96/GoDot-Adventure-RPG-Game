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

func _ready():
	save_settings()
	load_settings()
	
func save_settings():
	for section in _settings.keys():
		for key in _settings[section].keys():
			_config_file.set_value(section, key, _settings[section][key])
			
	_config_file.save(SAVE_PATH)
	pass
	
func load_settings():
	var values = []
	
	var result = _config_file.load(SAVE_PATH)
	if result != OK:
		print("Error loading settings. Error code %s" % result)
		return values
		
	for section in _settings.keys():
		for key in _settings[section].keys():
			var val = _settings[section][key]
			values.append(_config_file.get_value(section,key, val))
			# Printing the values for debug purposes
			print("%s: %s" % [key, val])
	return values
	
func get_setting(category, key):
	return _settings[category][key]


func set_setting(category, key, value):
	_settings[category][key] = value