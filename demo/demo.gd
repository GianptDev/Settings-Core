extends Node


func _ready():
	var color: = SettingsServer.add_setting("color", Color("ffffff"))
	
	# Connect the color picker to the option.
	# When the color picker change the color it will update the setting.
	get_node("ColorPicker").connect("color_changed", color, "set_value")
	
	# Connect the setting to the color rect.
	# When the setting change the rect will change color.
	color.connect("value_changed_to", get_node("ColorPicker"), "set_pick_color")
	color.connect("value_changed_to", get_node("ColorRect"), "set_frame_color")
	
	SettingsServer.add_setting("test", 12)


#load
func _on_Button_pressed():
	SettingsServer.open_settings("demo/test.tres")


#save
func _on_Button2_pressed():
	SettingsServer.save_settings("demo/test.tres")

