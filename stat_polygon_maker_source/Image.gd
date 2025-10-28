extends Sprite2D


const label_base = preload("uid://3d8dg2bpuajt")
var angles : Array[float] = []
var vertices : PackedVector2Array = []
var values_positions : PackedVector2Array = []
var divisions : Array[PackedVector2Array] = []
var R := 200
var center


##draws image
func _draw():
	##Background
	draw_rect(Rect2(Vector2(0,0), ConfigHandler.measures["IMG_SIZE"]), ConfigHandler.colors["BG_COLOR"])
	##Polygon
	draw_colored_polygon(vertices,ConfigHandler.colors["POLY_COLOR"])
	
	##Stats
	draw_colored_polygon(values_positions, ConfigHandler.colors["STATS_COLOR"])
	
	##Polygon Edges
	draw_polyline(vertices ,ConfigHandler.colors["LINES_COLOR"], 8, ConfigHandler.others["AA"])
	##Separation lines
	for i in vertices:
		draw_line( ConfigHandler.measures["CENTER"], i, ConfigHandler.colors["LINES_COLOR"], 2, ConfigHandler.others["AA"])
	##division lines
	var counter := 1
	for i in divisions:
		if counter == roundi(float(divisions.size())/2):
			draw_polyline(i, ConfigHandler.colors["LINES_COLOR"], 4, ConfigHandler.others["AA"])
		else:
			draw_polyline(i, ConfigHandler.colors["LINES_COLOR"], 2, ConfigHandler.others["AA"])
		counter += 1
	
	
	##Stats Line
	draw_polyline(values_positions, ConfigHandler.colors["STATS_LINES_COLOR"], 2, ConfigHandler.others["AA"])
	
	
##updates drawing	
func redraw(N : int, values : Array, names : Array):
	#ConfigHandler.reload_settings()
	
	##frees previous values
	angles = [] 
	vertices = []
	values_positions = []
	divisions = []
	
	for i in get_children():
		i.queue_free()
	
	
	center = ConfigHandler.measures["CENTER"]
	R =  ConfigHandler.measures["R"]
	var n_divisions = ConfigHandler.others["DIVISIONS"]
	
	for i in N:
		##sets drawing vectors
		var angle =  PI * 2 * i / N
		angles.append(angle)
		##Vertices of full poly
		vertices.append(Vector2 (center[0] + R * sin(angle), center[1] - R * cos(angle) ))
		
		##Vertices of custom poly
		var lenght = R * values[i] / ConfigHandler.others["VALUE_SCALE"]
		values_positions.append(Vector2 (center[0] + lenght * sin(angle), center[1] - lenght * cos(angle) ))
		
		
		##sets names and values
		if globals.show_names || globals.show_values:	
			set_label (names[i], values[i], angle)
	
	
	for i in n_divisions-1:
		var new_array : PackedVector2Array= []
		for angle in angles:
			new_array.append( Vector2 ( center[0] + (R * (i+1) / n_divisions  * sin(angle)), 
								center[1] - (R * (i+1) / n_divisions * cos(angle)) ))
		new_array.append(new_array[0])
		divisions.append(new_array)

	
	vertices.append(vertices[0])
	values_positions.append(values_positions[0])
	
	##show average
	if globals.show_avg:
		var l = label_base.instantiate()
		l.add_theme_color_override("font_color", ConfigHandler.colors["IMG_TEXT"])
		l.add_theme_font_size_override("font_size", ConfigHandler.measures["LABELS_FONT_SIZE"])
		add_child(l)
		l.text = "Average:\n" + str(snapped(globals.avg(values), 0.01))
		await get_tree().process_frame
		if ConfigHandler.others["AUTO_AVG"]:
			l.position = Vector2((ConfigHandler.measures["IMG_SIZE"])) - l.size - Vector2(2.5, 0.1)*ConfigHandler.measures["LABELS_FONT_SIZE"]
		else:
			l.position = ConfigHandler.measures["AVG_POSITION"]
					
					
	await get_tree().process_frame
	queue_redraw()
	
##creates name and value labes	
func set_label (lname, lvalue, angle):
	var l = label_base.instantiate()
	l.add_theme_color_override("font_color", ConfigHandler.colors["IMG_TEXT"])
	l.add_theme_font_size_override("font_size", ConfigHandler.measures["LABELS_FONT_SIZE"])
	add_child(l)
	
	l.position = Vector2 (center[0] + (R + ConfigHandler.measures["LABELS_DISTANCE"]) * sin(angle), 
						center[1] - (R + ConfigHandler.measures["LABELS_DISTANCE"]) * cos(angle)) 
	
	
	##small adjustments to y position
	l.position.y = l.position.y - l.size.y * (cos(angle)+1)/2 
	l.position.x +=  ConfigHandler.measures["LABELS_DISTANCE"] * 2*sin(angle) 
	
	##to account for origin being top right corner
	
	if (PI + 0.05 < angle and angle < 2 * PI - 0.05):
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	elif (0.05 < angle and angle < PI - 0.05):
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		
		
	if globals.show_names && globals.show_values:
		l.text = lname + "\n" + str(lvalue)
	elif globals.show_values:
		l.text = str(lvalue)
		l.position.y +=  20 * cos(angle)
	elif globals.show_names:
		l.text = lname
		l.position.y +=  20 * cos(angle)
		
	
