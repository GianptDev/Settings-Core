extends Node


func _ready():
	
	SettingsServer.add_setting("test", 12)
	
	if (SettingsServer.open_settings("demo/test.tres") == false):
		SettingsServer.save_settings("demo/test.tres")

