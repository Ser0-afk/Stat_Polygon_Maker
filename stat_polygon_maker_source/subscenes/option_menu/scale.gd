extends VBoxContainer

##keeps slider and input field values the same

func _on_scale_slider_value_changed(value: float) -> void:
	%ScaleValue.text = str(int(value))

func _on_scale_value_editing_toggled(_toggled_on: bool) -> void:
	if int(%ScaleValue.text) > 100:
		%ScaleValue.text = "100"
	%ScaleSlider.value = int(%ScaleValue.text)
