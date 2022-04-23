extends Node

# ==============================================================================


signal setting_created(_name, _setting)
signal setting_removed(_name, _setting)

signal settings_pre_saved(_resource)
signal settings_post_saved(_resource)
signal settings_pre_loaded(_resource)
signal settings_post_loaded(_resource)


# ==============================================================================


var settings: Dictionary = {}


# ==============================================================================


func add_setting(key: String, value = null) -> Setting:
	
	if (settings.has(key) == true):
		push_warning("Setting \"{name}\" already exist.".format(
			{ "name":key }
		))
		return null
	
	var setting: = Setting.new()
	setting.set_default(value)
	setting.set_value(value)
	
	settings[key] = setting
	emit_signal("setting_created",key,setting)
	return setting


func get_setting(key: String) -> Setting:
	var c: Setting = settings.get(key,null)
	
	if (is_instance_valid(c) == false):
		return null
	
	return c


func remove_setting(key: String) -> void:
	var c: Setting = settings.get(key,null)
	
	if ((is_instance_valid(c) == false) or (settings.erase(key) == false)):
		push_warning("Setting \"{name}\" does not exist.".format(
			{ "name":key }
		))
		return
	
	emit_signal("setting_removed",key,c)


# ==============================================================================


func get_setting_or_add(key: String, value = null) -> Setting:
	
	if (settings.has(key) == true):
		return settings.get(key, null)
	
	return add_setting(key, value)


# ==============================================================================


func open_settings(path: String, create_new: bool = true) -> bool:
	
	if (ResourceLoader.exists(path) == false):
		push_error("Setting resource \"{path}\" does not exist.".format(
			{ "path":path }
		))
		return false
	
	var resource: = ResourceLoader.load(path) as SettingsResource
	
	if (is_instance_valid(resource) == false):
		push_error("Setting resource \"path}\" failed to load.".format(
			{ "path":path }
		))
		return false
	
	emit_signal("settings_pre_loaded", resource)
	
	for key in resource.settings:
		
		if (settings.has(key) == true):
			get_setting(key).set_value(resource.settings[key])
		
		elif (create_new == true):
			add_setting(key, resource.settings[key])
	
	emit_signal("settings_post_loaded", resource)
	
	return true


func save_settings(path: String, override: bool = false) -> bool:
	var save: = Dictionary()
	var resource: SettingsResource = null
	
	if (override == false):
		
		if (ResourceLoader.exists(path) == true):
			resource = ResourceLoader.load(path)
			
			if (is_instance_valid(resource) == true):
				save = resource.settings
	
	for key in settings:
		var s: Setting = settings[key]
		
		if (s.is_archivable() == true):
			save[key] = s.get_value()
	
	if (is_instance_valid(resource) == false):
		resource = SettingsResource.new()
	
	resource.settings = save
	emit_signal("settings_pre_saved", resource)
	
	if (ResourceSaver.save(path, resource) != OK):
		push_error("Setting resource \"{path}\" failed to save.".format(
			{ "path":path }
		))
		return false
	
	emit_signal("settings_post_saved", resource)
	
	return true


# ==============================================================================
