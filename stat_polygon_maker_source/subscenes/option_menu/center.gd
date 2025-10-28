extends VBoxContainer

##change text when center is set to auto
func _on_check_center_toggled(toggled_on: bool) -> void:
	%HCenter.editable = not toggled_on
	%VCenter.editable = not toggled_on
	if toggled_on:
		%HCenter.text = str(int(%HSize.text)/2)
		%VCenter.text = str(int(%VSize.text)/2)
