extends PanelContainer

var OUTPUT_PATH
var N:=6
const setter_scene = preload("uid://etfxgbrrmww8")

##default dragging functions
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
	OUTPUT_PATH = ConfigHandler.others["OUTPUT_PATH"]
	%OptionsMenu.close_menu.connect(_on_options_toggled.bind(false))
	%Color_menu.close_menu.connect(_on_colors_selection_toggled.bind(false))
	
	%Options.modulate = ConfigHandler.gui_colors["BUTTONS"]
	
	N = ConfigHandler.others["STARTING_N"]
	for i in N:
		var new_sel = setter_scene.instantiate()
		new_sel.get_child(0).placeholder_text = "Value" + str(i)
		%Values.add_child(new_sel)

##changes option wheel colors when hovered on
func _change_wheel_color(hovered_on := true):
	if hovered_on:
		%Options.modulate = ConfigHandler.gui_colors["BUTTONS"].lightened(0.3)
	else:
		%Options.modulate = ConfigHandler.gui_colors["BUTTONS"]


##changes number of value setters based on N
func _on_number_selector_text_changed(new_text :String) -> void:
	var nN = int(new_text)
	
	##creates new setters
	for i in nN - N: 
		var new_sel = setter_scene.instantiate()
		new_sel.get_child(0).placeholder_text = "Value" + str(i)
		%Values.add_child(new_sel)
	
	##deletes setters
	for i in N - nN:
		%Values.get_child( N - i - 1).queue_free()
	
	N = nN


##Toggles
func _on_check_names_toggled(toggled_on: bool) -> void:
	globals.show_names = toggled_on
func _on_check_values_toggled(toggled_on: bool) -> void:
	globals.show_values = toggled_on
func _on_check_avg_toggled(toggled_on: bool) -> void:
	globals.show_avg = toggled_on

##open menus
func _on_colors_selection_toggled(toggled_on: bool) -> void:
	if toggled_on:
		%Color_menu.show()
		%Color_menu.move_to_front()
	else:
		%ColorsSelection.button_pressed = false
		%Color_menu.hide()

func _on_options_toggled(toggled_on: bool) -> void:
	if toggled_on:
		%OptionsMenu.show()
		%OptionsMenu.move_to_front()
	else:
		%Options.button_pressed = false
		%OptionsMenu.hide()



##saves image to output folder
func _on_save_pressed() -> void:
	##wait for rendering to finish
	await RenderingServer.frame_post_draw
	var image = %SubViewport.get_texture().get_image()
	
	##checks if folder exists and creates it if not
	var path = globals.create_path(OUTPUT_PATH, 1)
	
	globals.save_png(image, path, %Img_name.text)


func _on_draw_pressed() -> void:
	globals.rebuild.emit()


func _on_drag_button_up() -> void:
	pass # Replace with function body.


func _on_options_mouse_entered() -> void:
	pass # Replace with function body.
