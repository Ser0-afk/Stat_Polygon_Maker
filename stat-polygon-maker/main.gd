extends Control


const OUTPUT_PATH = "output/"

const setter_scene = preload("res://Setter.tscn")

@onready var N : int = %Image.STARTING_N
var values := []
var texts := []


func _ready() -> void:
	%SubViewport.size = %Image.IMG_SIZE
	
	for i in N:
		var new_sel = setter_scene.instantiate()
		new_sel.get_child(0).placeholder_text = "Value" + str(i)
		%Values.add_child(new_sel)
	
	_on_draw_pressed()


func _on_draw_pressed() -> void:
	
	##reset values
	values = []
	texts = []
	
	##gets values
	for i in %Values.get_children():
		values.append(int(i.get_child(1).text))
		texts.append(i.get_child(0).text)
	
	%Image.redraw(int(%NumberSelector.text), values, texts)


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


func _on_save_pressed() -> void:
	##wait for rendering to finish
	await RenderingServer.frame_post_draw
	var image = %SubViewport.get_texture().get_image()
	
	##checks if folder exists and creates it if not
	var dir_path:= OUTPUT_PATH.get_base_dir()
	if not DirAccess.dir_exists_absolute(dir_path):
		DirAccess.make_dir_recursive_absolute(dir_path)
	
	image.save_png(OUTPUT_PATH+ "image.png")


##Toggles
func _on_check_names_toggled(toggled_on: bool) -> void:
	globals.show_names = toggled_on
func _on_check_values_toggled(toggled_on: bool) -> void:
	globals.show_values = toggled_on
func _on_check_avg_toggled(toggled_on: bool) -> void:
	globals.show_avg = toggled_on
