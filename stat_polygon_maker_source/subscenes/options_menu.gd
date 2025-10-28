extends PanelContainer

##needed to reset main panel button appearance when closing
signal close_menu


##default dragging function
var offset
func drag_menu(dragging := false):
	offset = get_local_mouse_position()
	globals.drag.emit(dragging, self, offset)
func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_released("left_mouse_click"):
		drag_menu(false)
	if event.is_action_pressed("left_mouse_click"):
		drag_menu(true)

func _ready() -> void:
	set_values()

##sets menu values to stored ones
func set_values():
	%ScaleValue.text = str(ConfigHandler.others["IMG_SCALE"]*100)
	%ScaleSlider.value = ConfigHandler.others["IMG_SCALE"]*100
	%HSize.text = str (ConfigHandler.measures["IMG_SIZE"].x)
	%VSize.text = str (ConfigHandler.measures["IMG_SIZE"].y)
	%CheckScale.button_pressed = bool(ConfigHandler.others["SCALING_ON"])
	%CheckCenter.button_pressed = bool(ConfigHandler.others["CENTER_AT_CENTER"])
	%HCenter.text = str (ConfigHandler.measures["CENTER"].x)
	%VCenter.text = str (ConfigHandler.measures["CENTER"].y)
	%RValue.text = str (ConfigHandler.measures["R"])
	%LabelsDistanceValue.text = str (ConfigHandler.measures["LABELS_DISTANCE"])
	%AvgPosValuex.text = str (ConfigHandler.measures["AVG_POSITION"].x)
	%AvgPosValuey.text = str (ConfigHandler.measures["AVG_POSITION"].y)
	%CheckAvgAuto.button_pressed = bool(ConfigHandler.others["AUTO_AVG"])
	%DivisionsValue.text = str(ConfigHandler.others["DIVISIONS"])
	%LabelsFontSizeValue.text = str (ConfigHandler.measures["LABELS_FONT_SIZE"])

##restores values 
func _on_cancel_pressed() -> void:
	set_values()
	close_menu.emit()
	
##saves values and applies them
func _on_ok_pressed() -> void:
	ConfigHandler.save_settings("Others", "IMG_SCALE", float(%ScaleValue.text)/100)
	ConfigHandler.save_settings("Measures", "IMG_SIZE", Vector2i(int(%HSize.text), int(%VSize.text)))
	ConfigHandler.save_settings("Others", "SCALING_ON", %CheckScale.button_pressed)
	ConfigHandler.save_settings("Measures", "CENTER", Vector2i(int(%HCenter.text), int(%VCenter.text)) )
	ConfigHandler.save_settings("Others", "CENTER_AT_CENTER", %CheckCenter.button_pressed)
	ConfigHandler.save_settings("Measures", "R", int(%RValue.text))
	ConfigHandler.save_settings("Measures", "LABELS_DISTANCE", int(%LabelsDistanceValue.text))
	ConfigHandler.save_settings("Measures", "AVG_POSITION", Vector2i(int(%AvgPosValuex.text), int(%AvgPosValuey.text)))
	ConfigHandler.save_settings("Others", "AUTO_AVG", %CheckAvgAuto.button_pressed)
	ConfigHandler.save_settings("Measures", "LABELS_FONT_SIZE", int(%LabelsFontSizeValue.text))
	ConfigHandler.save_settings("Others", "DIVISIONS",  int(%DivisionsValue.text))
	
	
	
	ConfigHandler.reload_settings()
	globals.resize.emit()
	globals.rebuild.emit()
	set_values()

##closes menu keeping changes (not applied and lost on closing)
func _on_button_pressed() -> void:
	close_menu.emit()

##toggles auto avg positioning
func _on_check_avg_auto_toggled(toggled_on: bool) -> void:
	%AvgPosValuex.editable = not toggled_on
	%AvgPosValuey.editable = not toggled_on
	if toggled_on:
		%AvgPosValuex.text = str(int(%HSize.text)-75)
		%AvgPosValuey.text = str(int(%VSize.text)-90)


##also check ScaleField and Polygon scripts
