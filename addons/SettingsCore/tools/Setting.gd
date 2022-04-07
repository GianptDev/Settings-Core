extends Reference
class_name Setting

# ==============================================================================


signal value_changed()
signal value_changed_to(_value)
signal value_resetted()

# ==============================================================================


var value = null setget set_value, get_value
var default = null setget set_default, get_default

var archive: bool = true setget set_archive, is_archivable


# ==============================================================================


func set_value(v) -> void:
	value = v
	emit_signal("value_changed")
	emit_signal("value_changed_to",v)


func get_value():
	return value


func set_default(v) -> void:
	default = v


func get_default():
	return default


func set_archive(v: bool) -> void:
	archive = v


func is_archivable() -> bool:
	return archive


# ==============================================================================


func reset_value() -> void:
	set_value(default)
	emit_signal("value_resetted")


func is_default() -> bool:
	
	if (typeof(value) != typeof(default)):
		return false
	
	if (value == default):
		return true
	
	if (hash(value) == hash(default)):
		return true
	
	return false


# ==============================================================================


func get_bool() -> bool:
	
	if (value is bool):
		return value
	
	elif ((value is int) or (value is float)):
		return true if (value >= 1.0) else false
	
	elif (value is String):
		return true if ([
			"t","true","y","yes","k","ok"
		].find(value.to_lower()) != -1) else false
	
	elif (value is Color):
		return true if (value != Color("000000")) else false
	
	return false


func get_int() -> int:
	
	if (value is int):
		return value
	
	elif (value is bool):
		return 1 if (value == true) else 0
	
	elif (value is float):
		return int(value)
	
	elif (value is String):
		return value.to_integer() if (value.is_valid_integer() == true) else 0
	
	elif (value is Color):
		return value.to_rgba64()
	
	return 0


func get_float() -> float:
	
	if (value is float):
		return value
	
	elif (value is bool):
		return 1.0 if (value == true) else 0.0
	
	elif (value is int):
		return value
	
	elif (value is String):
		return value.to_float() if (value.is_valid_float() == true) else 0.0
	
	elif (value is Color):
		return value.to_rgba64()
	
	return 0.0


func get_string() -> String:
	
	if (value is String):
		return value
	
	elif (value is bool):
		return "true" if (value == true) else "false"
	
	elif ((value is int) or (value is float)):
		return String(value)
	
	elif (value is Color):
		return value.to_html()
	
	return ""


func get_color() -> Color:
	
	if (value is Color):
		return value
	
	elif ((value is int) or (value is float)):
		return Color(int(value))
	
	elif (value is String):
		return Color(value) if (value.is_valid_hex_number() == true) else Color("000000")
	
	return Color("000000")


func get_vector2() -> Vector2:
	
	if (value is Vector2):
		return value
	
	return Vector2(0,0)


func get_vector3() -> Vector3:
	
	if (value is Vector3):
		return value
	
	return Vector3(0,0,0)


# ==============================================================================
