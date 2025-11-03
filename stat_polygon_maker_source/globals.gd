extends Node

signal redraw
signal rebuild
signal resize
signal drag(dragging, scene, offset)

const VERSION = "2.1.1"

##editable from GUI
var show_names := false
var show_values := true
var show_avg := false



func avg(a : Array) -> float:
	var t := 0.0
	for i in a:
		t += float (i)
	return t/a.size()

func create_path(path : String, user :=true) -> String:
	var dir_path := ""
	if ! user:
		dir_path = "res://" + path
		if not DirAccess.dir_exists_absolute(dir_path):
			DirAccess.make_dir_recursive_absolute(dir_path)
	else:
		dir_path = "user://" + path
		if not DirAccess.dir_exists_absolute(dir_path):
			DirAccess.make_dir_recursive_absolute(dir_path)
	
	return dir_path
	
func save_png(img: Image, path : String, img_name = null):
	var counter := 0
	var regex = RegEx.new()
	if !img_name:
		img_name = "stat_poly_"
	regex.compile(img_name+"*")
	for i in DirAccess.get_files_at(path):
		if regex.search(i):
			counter+=1
	
	img.save_png(path+ img_name + str(counter) + ".png")
