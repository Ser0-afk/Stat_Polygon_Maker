extends SubViewportContainer


##standard dragging functions
var offset
func drag_menu(dragging := false):
	offset = get_local_mouse_position()
	globals.drag.emit(dragging, self, offset * scale)
func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_released("left_mouse_click"):
		drag_menu(false)
	if event.is_action_pressed("left_mouse_click"):
		drag_menu(true)
