extends PanelContainer

##needed to reset main panel button appearance when closing
signal  close_menu

const color_selector_scene = preload("uid://bt7mpy3im7ohk")

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


##instantiates color selectors
func _ready() -> void:
	for i in ConfigHandler.colors:
		var a = color_selector_scene.instantiate()
		%Colors.add_child(a)
		a.set_color(i, ConfigHandler.colors[i])
	
	for i in ConfigHandler.gui_colors:
		var a = color_selector_scene.instantiate()
		%GUI_Colors.add_child(a)
		a.set_color(i, ConfigHandler.gui_colors[i])
	
	await get_tree().process_frame
	%selector_container.custom_minimum_size.x = max( %Colors.size.x,  %GUI_Colors.size.x)
	%selector_container.custom_minimum_size.y = max( %Colors.size.y,  %GUI_Colors.size.y) + 40
	%GUI_Colors.hide()
	
##closes menu keeping changes (not applied and lost on closing)
func _on_close_pressed() -> void:
	close_menu.emit()

##save new colors and redraws
func _on_ok_pressed() -> void:
	for i in %Colors.get_children():
		ConfigHandler.save_settings("Colors", i.get_part(), i.get_color())
		
	for i in %GUI_Colors.get_children():
		ConfigHandler.save_settings("GUI_Colors", i.get_part(), i.get_color())
		
	ConfigHandler.reload_colors()
	globals.redraw.emit()

##returns to previous values
func _on_cancel_pressed() -> void:
	for i in %Colors.get_children():
		i.set_color(i.get_part(), ConfigHandler.colors[i.get_part()])
	close_menu.emit()

##reloads gui so gui changes have effect
func _on_reload_pressed() -> void:
	_on_ok_pressed()
	change_def_style()
	
	call_deferred("reload")

func reload():
	var _reload = get_tree().reload_current_scene()

func change_def_style():
	var def_theme = load ("res://assets/gui_style/DefaulTheme.tres")
	
	for i in def_theme.get_type_list():
		print (i)
		match i:
			"Label":
				def_theme.set_color("font_color", i, ConfigHandler.gui_colors["WINDOW_TEXT"])
			"LineEdit":
				def_theme.set_color("font_color", i, ConfigHandler.gui_colors["WINDOW_TEXT"])
				def_theme.set_color("font_uneditable_color", i, ConfigHandler.gui_colors["WINDOW_TEXT"] * Color(1,1,1, 0.5))
				def_theme.set_color("font_placeholder_color", i, ConfigHandler.gui_colors["WINDOW_TEXT"] * Color(1,1,1, 0.75))
			"CheckBox":
				def_theme.set_color("font_color", i, ConfigHandler.gui_colors["WINDOW_TEXT"])
				def_theme.set_color("font_pressed_color", i, ConfigHandler.gui_colors["WINDOW_TEXT"])
				def_theme.set_color("font_disabled_color", i, ConfigHandler.gui_colors["WINDOW_TEXT"] * Color(1,1,1, 0.5))
			"Button":
				def_theme.set_color("font_focus_color", i, ConfigHandler.gui_colors["WINDOW_TEXT"])
				def_theme.set_color("font_hover_color", i, ConfigHandler.gui_colors["WINDOW_TEXT"].lightened(0.3))
				def_theme.set_color("font_color", i, ConfigHandler.gui_colors["WINDOW_TEXT"])
				def_theme.set_color("font_disabled_color", i, ConfigHandler.gui_colors["WINDOW_TEXT"] * Color(1,1,1, 0.5))
				def_theme.set_color("font_pressed_color", i, ConfigHandler.gui_colors["WINDOW_TEXT"].darkened(0.3))
				def_theme.set_color("font_hover_pressed_color", i, ConfigHandler.gui_colors["WINDOW_TEXT"].lightened(0.3))
	
	var panel_container_style : StyleBoxFlat
	panel_container_style = load ("res://assets/gui_style/panel_container_style_box.tres")
	panel_container_style.bg_color = ConfigHandler.gui_colors["PANELS"]
	ResourceSaver.save(panel_container_style, "res://assets/gui_style/panel_container_style_box.tres")
	
	panel_container_style = load ("res://assets/gui_style/button_style_box.tres")
	panel_container_style.bg_color = ConfigHandler.gui_colors["BUTTONS"]
	ResourceSaver.save(panel_container_style, "res://assets/gui_style/button_style_box.tres")
	
	panel_container_style = load ("res://assets/gui_style/button_hover_style_box.tres")
	panel_container_style.bg_color = ConfigHandler.gui_colors["BUTTONS"].lightened(0.3)
	ResourceSaver.save(panel_container_style, "res://assets/gui_style/button_hover_style_box.tres")
	
	panel_container_style = load ("res://assets/gui_style/button_pressed_style_box.tres")
	panel_container_style.bg_color = ConfigHandler.gui_colors["BUTTONS"].darkened(0.3)
	ResourceSaver.save(panel_container_style, "res://assets/gui_style/button_pressed_style_box.tres")
	
	panel_container_style = load ("res://assets/gui_style/line_edit_bg_style_box.tres")
	panel_container_style.bg_color = ConfigHandler.gui_colors["LINE_EDIT_BG"]
	ResourceSaver.save(panel_container_style, "res://assets/gui_style/line_edit_bg_style_box.tres")
	
	panel_container_style = load ("res://assets/gui_style/line_edit_disabled_bg_style_box.tres")
	panel_container_style.bg_color = ConfigHandler.gui_colors["LINE_EDIT_BG"].lightened(0.3)
	ResourceSaver.save(panel_container_style, "res://assets/gui_style/line_edit_disabled_bg_style_box.tres")
	
	ResourceSaver.save(def_theme, "res://assets/gui_style/DefaulTheme.tres")

##swithces between img and gui colors
func _on_gui_img_toggled(toggled_on: bool) -> void:
	if toggled_on:
		%Colors.hide()
		%GUI_Colors.show()
	else:
		%Colors.show()
		%GUI_Colors.hide()
