extends Sprite2D




var colors
var measures
var others


const label_base = preload("uid://3d8dg2bpuajt")

var center 
var vertices : PackedVector2Array = []
var values_positions : PackedVector2Array = []


func _ready() -> void:
	colors = ConfigHandler.load_settings("Colors")
	measures  = ConfigHandler.load_settings("Measures")
	others	 = ConfigHandler.load_settings("Others")
	center = measures["IMG_SIZE"]/2
	
func _draw():
	
	##Background
	draw_rect(Rect2(Vector2(0,0), measures["IMG_SIZE"]), colors["BG_COLOR"])
	##Polygon
	draw_colored_polygon(vertices,colors["POLY_COLOR"])
	##Stats
	draw_colored_polygon(values_positions, colors["STATS_COLOR"])
	##Stats Line
	draw_polyline(values_positions, colors["STATS_LINES_COLOR"], 2, others["AA"])
	##Polygon Edges
	draw_polyline(vertices ,colors["LINES_COLOR"], 8, others["AA"])
	##Separation lines
	for i in vertices:
		draw_line( center, i, colors["LINES_COLOR"], 2, others["AA"])
	
	
func redraw(N : int, values : Array, names : Array):
	
	##if settings have changed
	colors = ConfigHandler.load_settings("Colors")
	measures  = ConfigHandler.load_settings("Measures")
	others	 = ConfigHandler.load_settings("Others")
	center = measures["IMG_SIZE"]/2
	
	##frees previous values
	vertices = []
	values_positions = []
	
	for i in get_children():
		i.queue_free()
	
	for i in N:
		##sets drawing vectors
		var angle =  PI * 2 * i / N
		vertices.append(Vector2 (center[0] + measures["R"] * sin(angle), 
								center[1] - measures["R"] * cos(angle) ))
								
		var lenght = measures["R"] * values[i] / others["VALUE_SCALE"]
		values_positions.append(Vector2 (center[0] + lenght * sin(angle), 
								center[1] - lenght * cos(angle) ))
		
		##sets names and values
		if globals.show_names || globals.show_values:	
			set_label (names[i], values[i], angle)
		
	vertices.append(vertices[0])
	values_positions.append(values_positions[0])
	
	##show average
	if globals.show_avg:
		var l = label_base.instantiate()
		add_child(l)
		l.text = "Average:\n" + str(snapped(globals.avg(values), 0.01))
		await get_tree().process_frame
		l.position = measures["AVG_POSITION"]
					
					
	await get_tree().process_frame
	queue_redraw()
	
	
func set_label (lname, lvalue, angle):
	var l = label_base.instantiate()
	l.add_theme_color_override("font_color", colors["IMG_TEXT"])
	add_child(l)
	
	if globals.show_names && globals.show_values:
		l.text = lname + "\n" + str(lvalue)
	elif globals.show_values:
		l.text = str(lvalue)
	elif globals.show_names:
		l.text = lname
	
	l.position = Vector2 (center[0] + (measures["R"]+ measures["LABELS_DISTANCE"]) * sin(angle), 
						center[1] - (measures["R"]+ measures["LABELS_DISTANCE"]) * cos(angle)) 
	
	
	##small adjustments to position
	##to account for origin being top right corner
	l.position.y  -= l.size.y * (cos(angle)+1)/2		
	
	if (PI < angle and angle < 2 * PI):
		l.position.x -= 2 * measures["LABELS_DISTANCE"]
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	elif (0 < angle and angle < PI):
		l.position.x += 2 * measures["LABELS_DISTANCE"]
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
