extends Sprite2D


const label_base = preload("uid://3d8dg2bpuajt")
var vertices : PackedVector2Array = []
var values_positions : PackedVector2Array = []

##draws image
func _draw():
	##Background
	draw_rect(Rect2(Vector2(0,0), ConfigHandler.measures["IMG_SIZE"]), ConfigHandler.colors["BG_COLOR"])
	##Polygon
	draw_colored_polygon(vertices,ConfigHandler.colors["POLY_COLOR"])
	##Stats
	draw_colored_polygon(values_positions, ConfigHandler.colors["STATS_COLOR"])
	##Stats Line
	draw_polyline(values_positions, ConfigHandler.colors["STATS_LINES_COLOR"], 2, ConfigHandler.others["AA"])
	##Polygon Edges
	draw_polyline(vertices ,ConfigHandler.colors["LINES_COLOR"], 8, ConfigHandler.others["AA"])
	##Separation lines
	for i in vertices:
		draw_line( ConfigHandler.measures["CENTER"], i, ConfigHandler.colors["LINES_COLOR"], 2, ConfigHandler.others["AA"])
	
##updates drawing	
func redraw(N : int, values : Array, names : Array):
	ConfigHandler.reload_settings()
	##frees previous values
	vertices = []
	values_positions = []
	
	for i in get_children():
		i.queue_free()
	
	for i in N:
		##sets drawing vectors
		var angle =  PI * 2 * i / N
		vertices.append(Vector2 (ConfigHandler.measures["CENTER"][0] + ConfigHandler.measures["R"] * sin(angle), 
								ConfigHandler.measures["CENTER"][1] - ConfigHandler.measures["R"] * cos(angle) ))
								
		var lenght = ConfigHandler.measures["R"] * values[i] / ConfigHandler.others["VALUE_SCALE"]
		values_positions.append(Vector2 (ConfigHandler.measures["CENTER"][0] + lenght * sin(angle), 
								ConfigHandler.measures["CENTER"][1] - lenght * cos(angle) ))
		
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
		l.position = ConfigHandler.measures["AVG_POSITION"]
					
					
	await get_tree().process_frame
	queue_redraw()
	
##creates name and value labes	
func set_label (lname, lvalue, angle):
	var l = label_base.instantiate()
	l.add_theme_color_override("font_color", ConfigHandler.colors["IMG_TEXT"])
	add_child(l)
	
	if globals.show_names && globals.show_values:
		l.text = lname + "\n" + str(lvalue)
	elif globals.show_values:
		l.text = str(lvalue)
	elif globals.show_names:
		l.text = lname
	
	l.position = Vector2 (ConfigHandler.measures["CENTER"][0] + (ConfigHandler.measures["R"]+ ConfigHandler.measures["LABELS_DISTANCE"]) * sin(angle), 
						ConfigHandler.measures["CENTER"][1] - (ConfigHandler.measures["R"]+ ConfigHandler.measures["LABELS_DISTANCE"]) * cos(angle)) 
	
	
	##small adjustments to position
	##to account for origin being top right corner
	l.position.y  -= l.size.y * (cos(angle)+1)/2		
	
	if (PI < angle and angle < 2 * PI):
		l.position.x -= 2 * ConfigHandler.measures["LABELS_DISTANCE"]
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	elif (0 < angle and angle < PI):
		l.position.x += 2 * ConfigHandler.measures["LABELS_DISTANCE"]
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
